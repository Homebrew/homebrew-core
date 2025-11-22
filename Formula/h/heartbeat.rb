class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.2.1",
      revision: "6485e11edf8854d7792dfc2999bf19db37315ea4"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dc6dc27bc879e301635b03a7570ce3f4df8d0f59999b1b233f7e8f826344008"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f51584a09c52ee0c5f81ccc38a4b026090d781a91002c65bdfdaad36024b606"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a8803d9013fa4c1b28915afbda7edcc09b3a4385e1ab4dbd51f18f84879bb89"
    sha256 cellar: :any_skip_relocation, sonoma:        "955e03b898f3e60dc2e567cc9c361891c68f337679814198f7effb6a5af35a07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d30c6fbb264d8c67a218a2f03ddf0ec2b2c97276d8d1896ca3835ea2b83f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4915b5b07d6269ffa8a0ecb12f3663b563c8517f13b32b7081d4763ee26f2c0"
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
