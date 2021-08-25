class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.101.0.tar.gz"
  sha256 "04caa5789da6162b693dbf1214ed80966ab48b536426717579d65097ae166f54"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d6952825bc23a28ec5360aee344e9f9c3e32fc418f5e0ae2cc0817c4aaa01ba2"
    sha256 cellar: :any_skip_relocation, big_sur:       "88002b83c32274f69cac81659e78445af7f2452f8a6c70352343390e9f6e9e79"
    sha256 cellar: :any_skip_relocation, catalina:      "5ef0724d5369edb253b1e29b9ef9aeb361a8307865cd6b45e77e93910e7bbed4"
    sha256 cellar: :any_skip_relocation, mojave:        "30290beb7725d4bd57cff1697037c4c010385e900dc2790070cd8febde3b8557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d80c33809f3d7b0636e0684ab1e94d59d343d323417fee66db578d3c7729e38"
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
