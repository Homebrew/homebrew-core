class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.13.1.tar.gz"
  sha256 "c8725d78e43b7d6a04465e8a156bc4c6a78121f291aac74e0b0a10286ef95544"
  revision 3

  bottle do
    cellar :any
    sha256 "feeb332067de2a86d4285dbf623a0d30bad7c81a4ae76ad4d4c88de2adfd2bfa" => :catalina
    sha256 "67501ce0ee2b962b2d103294b35cca6017172908ae75702c7b45a59bc065adfe" => :mojave
    sha256 "4b7fe6f22cf19db7b7565e3d3b8f06be8f15ce22e1a0adc1b40968de9b3eb0b5" => :high_sierra
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
