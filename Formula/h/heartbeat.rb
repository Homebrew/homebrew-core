class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.4",
      revision: "5449535b768a9308714a63dc745911c924da307b"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c430f945130ff1a1101b22717ca514963eaa85d30f3580df9ec966410dd583a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c96c43429343e966344d1a2f1d5c61358595daac95335ead37d9f7dbeaf3582"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d9713aefc34b176b7037d00b25c3d9518de01b2af0c401464d71aaa51ad6885"
    sha256 cellar: :any_skip_relocation, sonoma:        "0faa4f864a0ac2082d70515c0cabf9b937f2531ec73e8da277102d5db2abf8bc"
    sha256 cellar: :any_skip_relocation, ventura:       "c8635d0c8fd0cf6b869b9f128f67088acbe6fab5f457aef74d45d78ff64c3198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa05bee84e468750a3a518a8d0c7ac86af0041828fb02c9cc86a3c991161b1e"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "netcat" => :test

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docs/tests
    rm buildpath.glob("**/requirements.txt")

    cd "heartbeat" do
      # don't build docs because we aren't installing them and allows avoiding venv
      inreplace "magefile.go", "(Fields, FieldDocs,", "(Fields,"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["heartbeat.*"], "fields.yml"
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
