class Pdfcrack < Formula
  desc "PDF files password cracker"
  homepage "http://pdfcrack.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.14/pdfcrack-0.14.tar.gz"
  sha256 "ac88eca576cebb40c4a63cd90542664de7d8f1b39885db5a7ac021d8b0c6a95c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6519520585b6891b2c38665cbb419476c33568d182097ab2d3d49814b5518955" => :sierra
    sha256 "0166c0baab213495fe05900618c78c4a24b64374b8fb85aa4ec9b5830911799b" => :el_capitan
    sha256 "6159727d39c2e9ca7ed22bdcdda8f8b6e3a9de7cb00a78d3c19f6d82185db7fc" => :yosemite
    sha256 "6e7e5c24781fb1248c1bf868b10febcaaff7bd92bd7f507cb140bff9cab05982" => :mavericks
  end

  def install
    system "make", "all"
    bin.install "pdfcrack"
  end
end
