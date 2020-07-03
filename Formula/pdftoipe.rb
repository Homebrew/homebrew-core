class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.13.1.tar.gz"
  sha256 "c8725d78e43b7d6a04465e8a156bc4c6a78121f291aac74e0b0a10286ef95544"
  revision 7

  bottle do
    cellar :any
    sha256 "fe44f5737ca3c17a463840f24d039579993f4e6b6c9668e3f8407010e459159b" => :catalina
    sha256 "55ea30e61e651d848f3733cf64f5dbd807575985873590fb259eea3c20e70b12" => :mojave
    sha256 "b9f0830ed0e03b2e10f38cf30c14385ef58f6875e4189a8d03fa610c1e4c9567" => :high_sierra
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
