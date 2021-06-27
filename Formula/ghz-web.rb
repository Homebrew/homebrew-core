class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.96.0.tar.gz"
  sha256 "0494ca18d7cbad00f2d37aba8494d7fda9d16ddc9146218ebbcb7a605f3a668f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8b7ae272239f41f91ed0c9b3d9a1957808d778d0b53486f51703c39d5d576fcc"
    sha256 cellar: :any_skip_relocation, big_sur:       "29328462152039538f12493e77b0e6aecd9d717d1679707c993e0d44a75e1d8e"
    sha256 cellar: :any_skip_relocation, catalina:      "3cf03a23253c23bafd386724e8ae5f48eaa4154996a6a0deb9122cb63798d568"
    sha256 cellar: :any_skip_relocation, mojave:        "98846937b0d70bde0f57498365258dd6e6721c9f482ed0ac2de17e15b6f86963"
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
