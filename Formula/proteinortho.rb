class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.27/proteinortho-v6.0.27.tar.gz"
  sha256 "bf8a1e6163bfb184db03a2b1210dc94899766e416f3083ca347a5044903c7e6e"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "0f1bac2f4d54cb0ccd297f0f218b2939049346138402b2a6bb1d260f765f3653" => :big_sur
    sha256 "ce57c0d39cc04ae0fb66d75dcbe4914732a1910231f5a53b928429b16b9946af" => :arm64_big_sur
    sha256 "013a714bc1311133376e61df6f4f88e2974cb5622693650249a6b5e1c443686a" => :catalina
    sha256 "b0e2209fc305fabdfd9e83366b3aea7da475a56bdd0ffcbe63525f16d7c889c9" => :mojave
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
