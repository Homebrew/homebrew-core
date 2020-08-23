class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.13.1.tar.gz"
  sha256 "c8725d78e43b7d6a04465e8a156bc4c6a78121f291aac74e0b0a10286ef95544"
  license "GPL-2.0"
  revision 7

  bottle do
    cellar :any
    sha256 "2a87dbf06db83c9d397994817e64c6727c1dc593f6263822ca80d050f2495e56" => :catalina
    sha256 "d6ad23747f3c1319cbbe7e2b1faf6f91c68199d4ef712a8e1005082acb526451" => :mojave
    sha256 "bfbb2639bc3c0817f2a05fcfcceca6bd8741103f04a7f81826eb5d1dc6541880" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    ENV.cxx11

    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
