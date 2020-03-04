class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.14/proteinortho-v6.0.14.tar.gz"
  sha256 "b7653d3b5f71331154625c3d4a62a1ebaf1fa24c77f4e2f3f99fc8c08fe3c743"
  revision 1

  bottle do
    cellar :any
    sha256 "0f3c223913f2bd87bf6ed088f9df0ca9bc6531722de436d994ccf8a0b94d6428" => :catalina
    sha256 "b512a8da7d2c19aeb7d509c48de28b6997c33666c9f0cb5c6f57518d5827efdd" => :mojave
    sha256 "01199941ee6c99367583eef697a0aa84e6d780ab6746bc856b9835f1040e79be" => :high_sierra
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
