class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.2",
      revision: "1ebd0940bd56943642ea8d63d1fe8227f86e7435"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7c2813e08476efe1a30b1f197f57fb34ac42ca89f63a29621f965891aa55597"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ef0ef548710f10ae94e944e4dc6ab73540cf438b01d792d874b1d4b3302d746"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e995c0ac1ad8bdd50c38641aa26b2bf2a94ad3ac8f467b5cfaff4fb73a19ba8"
    sha256 cellar: :any_skip_relocation, ventura:        "7cb64c42313282e7f4d6662b42b912f77c2c0dab4cd9df8032485e5fc5405df4"
    sha256 cellar: :any_skip_relocation, monterey:       "82130c68ee3eaa973205e665404c7fc21b78e3c6fd0413fa03630ffba3eef670"
    sha256 cellar: :any_skip_relocation, big_sur:        "60b9b4ee6861391013533127b228232b191ba5b7af95f60af0ba26d9f3b81a24"
    sha256 cellar: :any_skip_relocation, catalina:       "229a78e622640a6406ad05cf10faf0f9531d417f7420167b439d1aa47d0cacda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1faa14814140cbbca2f46a4b82d09e748cff168c559105a54d1f87e3b09c5f6f"
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
