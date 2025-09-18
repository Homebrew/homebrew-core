class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.3",
      revision: "d9d2860c7593868e25d1b2da7da43793fe12c99e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a396be067087dfd0454adcae4cdab51fc3b02cd001dd97230c612cc3bfb5f32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72d30c8421254c428358fcfed9664c5db3fceb81edda47e95fcdb229f11a2519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54a93112b9f23d9c6814d96e736747a6dc9f3e195a8fd46075505e218067bb89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "757269d1b395b328213cac1e1b634ab587f809e033e4037f1e2b7d06ceef6b81"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe8d092a38645e210e449a11d5d7e25b95a42c77e9e185fee5a341b8b4be6536"
    sha256 cellar: :any_skip_relocation, ventura:       "0be8cf2493e9e81016cdcd03122f35207935378562db74bda75c95847eb1d779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d947ed26556f39d4f304eb5d63ea9ee81c31bc92b7553a693858e65218adb4de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8494f26700bad0fc0572014163a879eada2fc1bf670920f3fe1ede9ea2597565"
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
