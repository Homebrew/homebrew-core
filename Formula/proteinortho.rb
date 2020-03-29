class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.14/proteinortho-v6.0.14.tar.gz"
  sha256 "b7653d3b5f71331154625c3d4a62a1ebaf1fa24c77f4e2f3f99fc8c08fe3c743"
  revision 1

  bottle do
    cellar :any
    sha256 "97af1c79b3fc50fe60be20c29e576d0eda3064c4c98db67f67097c8128402e64" => :catalina
    sha256 "b0a02cc76066cbb403ff5f775566f78b29e3418f55a600faf9938fa6ceafbbb2" => :mojave
    sha256 "75fbe6710c104a16f80c49b583fb253bca8c96762f7bdf4c0c0dc44be32ee0d0" => :high_sierra
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
