class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.35/proteinortho-v6.0.35.tar.gz"
  sha256 "1aa4a887d82a1074f1032d5a56858b35505d4c9937080a4f366fbdcc83e483d3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "469b94aa5b70464dd40543a1a7106898d73b1ed803f07d6d6470cf7b7797e63f"
    sha256 cellar: :any,                 arm64_big_sur:  "e86e18cdee9b81485c286abaadba5ba5033cb7bd8a98cbbce5f91da425fe83b1"
    sha256 cellar: :any,                 monterey:       "d2dfc2187c30b3e691186e4af047acf72f17c0f2a5389e5e5804ce68af6f15c2"
    sha256 cellar: :any,                 big_sur:        "5491084133942279b0786c74395c59cbf5024bd90603b56ede99fb3d90d8f745"
    sha256 cellar: :any,                 catalina:       "d604bc70207fc987ad4781e82585730db96421e8b115a8412ea08aadc0a1bae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c86582443280a720052fae0c67e9fda0f3896e32e1e23d8b8134d030fac6becd"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
