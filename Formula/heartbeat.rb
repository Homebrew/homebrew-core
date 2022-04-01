class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.1.2",
      revision: "6118f25235a52a7f0c4937a0a309e380c92d8119"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08718867d92b84c3aafcd065010f255946ba60a603e95a6f47b267189bb2b90e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b1949258887e7b16a6e7291f89b7e017735645750d846704b9b06aca5abbd8d"
    sha256 cellar: :any_skip_relocation, monterey:       "89e6f6973131050a8e2495e60fd96b7c8979eea995ca3e660da7320aaaacd265"
    sha256 cellar: :any_skip_relocation, big_sur:        "f96ba15e160a949a00c4ec22bd525b0d61a9088ded9a259ed2d9a698b3f97e44"
    sha256 cellar: :any_skip_relocation, catalina:       "2ea823fbc2c21da07ea33c01853f5e7f98d6722d213213e23624dfc538c25a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d688862f1e3433bc7644a56afcdbeccc7065f0aeabde2b4ee5e28912136d29e3"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build
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
