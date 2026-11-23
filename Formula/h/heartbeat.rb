class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.7",
      revision: "9455ccba703306aae4ed36b86a03976c963c0186"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    manifest_sha256 "b93a68fbee24fc3dd7bf2b849cba4269446a9a62247f1ff39caad1e0e2c59bed"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aa99691c5a7a1a69c14530c66957956ff915937d39eb5a836fca39470c2d6007"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7a3ebdbab3f289eb2acf5b624470de473aa27b5ef4ad2ff807b1e95cc1fef91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0452ff9fd445cdc439ab5de9490d9307f3616155acb5bfe127a9eaa60ea25be"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c9f6b2626cf04964adeaedb1aac177f4dfb4d51691f090ebd0264d6df49a4171"
    sha256 cellar: :any,                 x86_64_linux:      "a2205b3b173a0fefd3cd1ec8da30bf7e839bdc9e5468995757820c085055cb97"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  # `test do` block runs a local TCP server for the monitor to check
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
