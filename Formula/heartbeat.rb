class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.2",
      revision: "9b77c2c135c228c2eedc310f6e975bb1a76169b1"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9107c213f4b9e1ef330d9d640a8a499841e0ba4affc0f43b0d7b97c7dfdce72c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f56366cb957a37e09cb964bc4bd1f10b2bb58651a25edd2c219cbcb5ef7d4b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "512c1bc278eac2ca0561cb955b1cdba3a45f124e0fd6d0fddcf80ce50df7615f"
    sha256 cellar: :any_skip_relocation, ventura:        "489fa313897ce3bb57824611d61848b725512d9477355baf13a2c0440fafb6d4"
    sha256 cellar: :any_skip_relocation, monterey:       "59f3d8a66c4a12f544a9d37b483cc118a374c824ce396efb9545b1efb7afa119"
    sha256 cellar: :any_skip_relocation, big_sur:        "96e0fc7fcba3059537d1e8440234d309aabf16ef82c2827e6e597bed0c127042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e40d669a6ccc7e549f54f3673c7056ac6569b3fe305c832d7ef422cc9fa70a98"
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
