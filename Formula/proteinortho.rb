class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.8/proteinortho-v6.0.8.tar.gz"
  sha256 "41ab67e7a2c26976c295c474faecb93607f191e2da6ee059e353da7c50217dec"

  bottle do
    cellar :any
    sha256 "c0206949a5e537b5d3daacfd1010e81dade04d7a00adf3b9b96596ebabaeb9b9" => :catalina
    sha256 "ed8528af7ca2055297c982a6eda3971c7daf509dee19f1da50299afd4dedbf9c" => :mojave
    sha256 "04ab26f4ceba13bd184bc07fff27eb066acb186f2faf4bfb85634a084aa2bbf8" => :high_sierra
    sha256 "6659daa6dc141bb7a229fe3820bb3676160ea1d7726d73797387c9c22a092e45" => :sierra
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
