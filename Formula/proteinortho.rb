class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.18/proteinortho-v6.0.18.tar.gz"
  sha256 "c9157bd6c6498d5d54af86acd2a55217c3815177848dc1d4e1e29c514950c00e"

  bottle do
    cellar :any
    sha256 "566a8f9d0ed9363380d69142b11c053687d502472445c8355788b77456855efc" => :catalina
    sha256 "9c286d9ee4fba3275ab9ef6c8578e77fd30131ba1bf262e424e93e20450fc81a" => :mojave
    sha256 "9524f1b15a90d1c16ed2a6239b22be8a8511d2ef61fb7d51ddd9a83b82fac2f3" => :high_sierra
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
