class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "4d8f10c1fedd1acc3b46bde27839349a61b77623dad25437d4aa41d41b502660"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae970f26aaeca09351fc0087ec22a2873edcb970c52df5adc2e6a2fbdd31de00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a312a0c222535af8f71f9e2179ad6f289ccd2b50a560ce10a8808270c82efc87"
    sha256 cellar: :any_skip_relocation, monterey:       "b1e926b1bd0cd711c4fce909a6795037c7ac69bb55758f228b82372b57aedb98"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd2a155b2ae2115dd615da5d92a089def01f6682c18d517d2b326f7fd491541c"
    sha256 cellar: :any_skip_relocation, catalina:       "0a6f0ccd1dcde65f1f1cd52bf15d9a294a33113a3888f42fd79ca5134a449af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a86389fbbe47965e870d4229b0beabdab841c3dcbb6960f3912acb88ddf245e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    fork do
      exec bin/"livekit-server", "--keys", "test: key", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
