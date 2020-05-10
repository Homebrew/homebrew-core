class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.16/proteinortho-v6.0.16.tar.gz"
  sha256 "2a076ab2ac1dc525a27e6be61bdc2075587024fd1a4604d8eea4701cbbefc119"

  bottle do
    cellar :any
    sha256 "bfbe79d1bab5b876e769f28f9f3eb60134af02e50f24104a4bf4bbd06f2d6b18" => :catalina
    sha256 "1956c5039eb9b4527113c85bf60fc4c904380a7e8feef4e681e78568d4c6c4cd" => :mojave
    sha256 "8a30e262a01ff066558748f5bdff4d563cdd17aaafc57910782cc5540b92b353" => :high_sierra
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
