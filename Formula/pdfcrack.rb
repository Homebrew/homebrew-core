class Pdfcrack < Formula
  desc "PDF files password cracker"
  homepage "https://pdfcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.15/pdfcrack-0.15.tar.gz"
  sha256 "791043693f9fc261fa326dbcb5e4de3801d6ae552dbea39293f9b2674c250d3e"

  bottle do
    cellar :any_skip_relocation
    sha256 "29d9fae755ec6f86bd6ef162a100708a4b70ca8df16dfab56c6bd9716e804cdb" => :sierra
    sha256 "95bdf77c94c37277e1539d9db15e843a3787d9554c7715bfef839db5535adaca" => :el_capitan
    sha256 "77c9f14f30a06181c2d4777f8a3ec7dda02d45bf7a502ef6c03c5cf7fbbada4e" => :yosemite
  end

  def install
    system "make", "all"
    bin.install "pdfcrack"
  end
end
