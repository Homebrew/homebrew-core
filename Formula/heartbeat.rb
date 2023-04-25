class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.7.0",
      revision: "a8dbc6c06381f4fe33a5dc23906d63c04c9e2444"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0b6a8a9acc05e1bb9bdcc23b313e1399fda7d3eb297e8b2b10ae821b6b0b6d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "309f8623193c6b7aa8c2890ede843e0e7928eb934e9f18b89f1205fb40034739"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0af6d664349cbfde413c3b608fd7aa09e6bb5821b286b585cfe02f8176333a2d"
    sha256 cellar: :any_skip_relocation, ventura:        "2f6ed1d943980fb66c6303515b33155acf4f88c37fbf858ed1c2676e58cbb840"
    sha256 cellar: :any_skip_relocation, monterey:       "9e5a81dc3194762b0e0d27aec6204d2c61f12726a24410decf68e8fb12710e00"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ff332f7b26281c8704be7384b2d23dfd8a9c14d8de0a9239fa6f307f1b9c034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f06e643f30ae4630491c878a5dca1e3cf8c96b72775731a7ee4a83cbd60b735"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build
  uses_from_macos "netcat" => :test

  def install
    # remove non open source files
    rm_rf "x-pack"

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

    port = free_port

    (testpath/"config/heartbeat.yml").write <<~EOS
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
    EOS
    fork do
      exec bin/"heartbeat", "-path.config", testpath/"config", "-path.data",
                            testpath/"data"
    end
    sleep 5
    assert_match "hello", pipe_output("nc -l #{port}", "goodbye\n", 0)

    sleep 5
    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("heartbeat-*.ndjson") do |file|
      s = JSON.parse(file.read)
      assert_match "up", s["status"]
    end
  end
end
