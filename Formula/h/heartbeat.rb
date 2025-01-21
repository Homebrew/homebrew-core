class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.0",
      revision: "092f0eae4d0d343cc3a142f671c2a0428df67840"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8e753ec2d5880405874e61abb16bf6e5e87487f3a258221c1970958b4505e8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef5c6cf2eab88ef9df06a4ef21a033622773509d7b7df3f41eef9661cce84d6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5435c9222244b883d9fce1585f92917b1f180873d6796ee1d326dab2ea538dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0011afb9fc0674b9228e06670797ec9dd900aff9afc7b6b8e7db00f90bdd27d5"
    sha256 cellar: :any_skip_relocation, ventura:       "5a7b3d88df68366869d274e04a0d402e56c3b5473d8ceaea2b457faed6fde483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f25e3043fb84fb08e390055bdb44ed2c6efd7d0899affe519b8edcb47158e20"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "netcat" => :test

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "heartbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"heartbeat").install Dir["heartbeat.*", "fields.yml"]
      (libexec/"bin").install "heartbeat"
    end

    (bin/"heartbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/heartbeat \
        --path.config #{etc}/heartbeat \
        --path.data #{var}/lib/heartbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/heartbeat \
        "$@"
    EOS

    chmod 0555, bin/"heartbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"heartbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var/"lib/heartbeat").mkpath
    (var/"log/heartbeat").mkpath
  end

  service do
    run opt_bin/"heartbeat"
  end

  test do
    # FIXME: This keeps stalling CI when tested as a dependent. See, for example,
    # https://github.com/Homebrew/homebrew-core/pull/91712
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    begin
      port = free_port

      (testpath/"config/heartbeat.yml").write <<~YAML
        heartbeat.monitors:
        - type: tcp
          schedule: '@every 5s'
          hosts: ["localhost:#{port}"]
          check.send: "hello\\n"
          check.receive: "goodbye\\n"
        output.file:
          path: "#{testpath}/heartbeat"
          filename: heartbeat
          codec.format:
            string: '%{[monitor]}'
      YAML

      pid = spawn bin/"heartbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "hello", pipe_output("nc -l #{port}", "goodbye\n", 0)
      sleep 5

      output = JSON.parse((testpath/"data/meta.json").read)
      assert_includes output, "first_start"

      (testpath/"data").glob("heartbeat-*.ndjson") do |file|
        s = JSON.parse(file.read)
        assert_match "up", s["status"]
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
