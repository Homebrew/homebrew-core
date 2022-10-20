class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.6.1.tar.gz"
  sha256 "4b41175e552dd198bb9cae213df3c0d9ca8cacd0b673f79d26419cea7cfb2df7"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "721a009f4330a15efe56180635ecb04fe9efc196cf31257db8eb8aed004b2486"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a64e295b739fb8ea34a90e160123ff4f12212f04f1858af01550b89b7acf987"
    sha256 cellar: :any_skip_relocation, monterey:       "e638635583b185c703c11507f6105f8a1b25e5da3d45e2cfbfa39170e2f541a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe3d2a287c483eb1253773509159b7366b887540c22e220dafc3e2ebc6f621b8"
    sha256 cellar: :any_skip_relocation, catalina:       "a61b0b244d3650f3ea2fc312dfa6d745ec853efa8160ceb7008a44f7bc993df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5f881ba846aa8cde80623002319f31016006836ba5f010ee94febc07e7e4a6d"
  end

  # Required latest https://pkg.go.dev/go4.org/unsafe/assume-no-moving-gc
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
