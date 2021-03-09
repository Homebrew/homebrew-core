class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.93.0.tar.gz"
  sha256 "b52d3e6204cc6f34f2ff6175e77225b80657a9b623e9bdba61727d681bb9fd82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b40a5a9d5c6854421b58d9fc77a39107f603df78aacfaf063ba95867dccf8289"
    sha256 cellar: :any_skip_relocation, big_sur:       "4047299af215f163e46227a0a362d1225473426230f8e444485c6faf387f6cac"
    sha256 cellar: :any_skip_relocation, catalina:      "1d0cd114609231dcc467002346226093b2a1f8e964dfb00125945caf95c7c72e"
    sha256 cellar: :any_skip_relocation, mojave:        "3baa37ae4e7e66b58f431230b1fff2c9d1cb1e8742d71f0d7f6695be1b820e26"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
