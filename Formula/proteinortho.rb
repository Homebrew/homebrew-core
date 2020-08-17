class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.21/proteinortho-v6.0.21.tar.gz"
  sha256 "fa7177da0f3fe42eb59f6287c52e05568b4f4cb9c4e2b1640ac87af6c9080420"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "ab368828d21ad513a6ed925bf29dd9604d3543a1a9197c9c7831a8a5a032d6a4" => :catalina
    sha256 "1a43e61b9f13049ae545a6adfba74a583ff3d01b63eca0b73e3d26c0fe1fbc14" => :mojave
    sha256 "f037b6504487a0552e7bf563618942ba79fd2bad0c6271b1b919151528e9a346" => :high_sierra
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
