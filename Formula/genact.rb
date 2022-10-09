class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v1.2.0.tar.gz"
  sha256 "bcbcceaadab49f0dc86a5f3fa6235eea4f08d835f717b098c8e3a38c897c3221"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89ed51d8655586d5ad825d68a32024928f6dd3e320bffb41a8904358a145e49e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d00008a0d2d508b2bfa99893b9b8a639aa205070c15e57ff6a3910a3c405ca85"
    sha256 cellar: :any_skip_relocation, monterey:       "f7eb817897921a01a64cff11536b366f8937c5974f88e70a6d3223258cbce898"
    sha256 cellar: :any_skip_relocation, big_sur:        "a45b49d4bda05d0fc9556c5925c4aea53bc89017ede5477a0d9be2620ef36623"
    sha256 cellar: :any_skip_relocation, catalina:       "80da481cd24279859017296c0124a2aca438ed115b703bd6a5442af73b5f67c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bacc60d0958df84d21d9a4b36cc6cce0088faa56fd4be03e973994cb8ef75098"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
