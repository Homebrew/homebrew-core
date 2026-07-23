class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.4.4",
      revision: "45b2d3821c3ff0da055e025ec16a126c27423462"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6614d08599f5e2b6130b25524fb2f2500481517ad2e280625ad3a9d0456e7056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73767b7752bc587b1e7f2a5de5ef1813e62ee651c11a7f7a3146faff22fd1917"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d8f7c96ba0b82e9d3dd6c3bd9674a786fdbb76ffee53432295ccd0b1a8eda58"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f6ff324ca86eb29ded93747378aec4ae343589a5126a08b961d920727792def"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b171e0d3d562c9161517a0b4a22821c7c686a3a7eedd8e15774d918ed5490ad2"
    sha256 cellar: :any,                 x86_64_linux:  "99c19090cf2d9426c735e75b7518c27daceb2d1930edb38bb3f1b2ef8f43ec28"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docs/tests
    rm buildpath.glob("**/requirements.txt")

    cd "heartbeat" do
      # don't build docs because we aren't installing them and allows avoiding venv
      inreplace "magefile.go", "(Fields, common.FieldDocs,", "(Fields,"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["heartbeat.*"], "fields.yml"
      (libexec/"bin").install "heartbeat"
    end

    (bin/"heartbeat").write <<~SH
      #!/bin/sh
      exec #{libexec}/bin/heartbeat \
        --path.config #{etc}/heartbeat \
        --path.data #{var}/lib/heartbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/heartbeat \
        "$@"
    SH

    chmod 0555, bin/"heartbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"heartbeat", "completion", shells: [:bash, :zsh])
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
      TCPServer.open(port) do |server|
        session = server.accept
        assert_equal "hello", session.gets.chomp
        session.puts "goodbye"
        session.close
      end

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
