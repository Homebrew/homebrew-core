class FuegoFirestore < Formula
  desc "Command-line client for the Firestore database"
  homepage "https://github.com/sgarciac/fuego"
  url "https://github.com/sgarciac/fuego/archive/refs/tags/0.33.0.tar.gz"
  sha256 "25281f2242fe41b0533255a0d4f0450b1f3f8622d1585f8ae8cda1b116ca75d0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2872ea1f2d75bf1fefab9c7865e37f875ba0441734ce0b70666e394d4c10efed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc240ed9789e51dd98fc97fdf57ef8efd0e958a1d4cdcc0ca04e0e64514428c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40f3d2090e79cdb60d7dd33c6e73770b95315104946b4bf3c92411818440f26e"
    sha256 cellar: :any_skip_relocation, ventura:        "51cd39fc722f623c19f313938fe4d361e180ec432e4e90f5941c6144e8a30f3b"
    sha256 cellar: :any_skip_relocation, monterey:       "d9b1c188b58dcf13c0739fb9d28ee1c5120896b8c102aaf021116fd95ab8808e"
    sha256 cellar: :any_skip_relocation, big_sur:        "74a6937a4934a46b957dcfc32647258e6a6cd5e6f3ab169daa8289323eadce36"
    sha256 cellar: :any_skip_relocation, catalina:       "700165708e3a16b6d3abb5da34713a92b34dbb1acbb5b212c23165192938748f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cdf98e557eef00cb0e50546607d62df01656e47f1834b270041755b64693045"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"fuego", ldflags: "-s -w")
  end

  test do
    collections_output = shell_output("#{bin}/fuego collections 2>&1", 80)
    assert_match "Failed to create client.", collections_output
  end
end
