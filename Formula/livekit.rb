class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "4f25983914a2611ad7f534f0d76204c0f39c81b670272903ca10f2119f4ea257"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d6964f136b42a0be292f52038bd5a489e5aaa7f77840ddff658827a7a6bef26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "108935eaf2a965f36ca25747a0a664dff5ad6bcd601511a88c572e48091cb597"
    sha256 cellar: :any_skip_relocation, monterey:       "ee37ae1da861d2cc921d2783aa9fb0db699f349011d2beefdbdadc5687131774"
    sha256 cellar: :any_skip_relocation, big_sur:        "3df1ed2c4b285d8d8422432f0bf9f15031dcdca07c34c0cb2a1ba0ef02a7fc4a"
    sha256 cellar: :any_skip_relocation, catalina:       "8628675d413ed5339f6cb9437208aa1de1c00e46d0e5ef00c1f959f9be34b7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebbd3ce822fac187232cdf7fd99f9ef5d1e16323f54ca9e00a079fc2d065029a"
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
