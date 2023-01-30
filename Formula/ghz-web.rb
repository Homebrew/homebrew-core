class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.113.1.tar.gz"
  sha256 "5515be2353f538afd5f51d8ee769dfe46b063582c99fdf892efb2cd3bad83c74"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56b746f4cb76141f33927f84ee06c3730933f9e8a418cdf4ad588c46c1d971d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da3862ff9bc1be4bcbea56729b9a5dd310c3a853968b97b7a3584e14e7be5ad9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d3c06809dc4e79d2162f66f20dc61b4ab860970eb64b6e42fb10b297c99b1ca"
    sha256 cellar: :any_skip_relocation, ventura:        "89dcd69efc503b88beddbbece56e710eb1e108c450c0fdfebb9a46c47d9f153e"
    sha256 cellar: :any_skip_relocation, monterey:       "c6de4878baa19a8757ebf9ab7c7857c542b66e7da3eb4222b9deb2b02177d327"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e2f5d6fdcb742737b597e555dca496eddad244f2a968383602767bcadb9d24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11fd0cf891516089e5beb570852297b19ab1cfe945383214953a161ab2f540b0"
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
