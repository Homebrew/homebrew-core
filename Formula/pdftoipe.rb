class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.13.1.tar.gz"
  sha256 "c8725d78e43b7d6a04465e8a156bc4c6a78121f291aac74e0b0a10286ef95544"
  revision 1

  bottle do
    cellar :any
    sha256 "51a62eadc1df0e45c25ff4889fc2b47539c7f28424f2438b14ea2e8436b1e478" => :catalina
    sha256 "46d256f6e8100c4c9aa7026b0735054a02b4e730b18def8b193909f73fd9407d" => :mojave
    sha256 "d62d60ee2dd612bcb88360bd24735db6a28d0ae327671c9c7a8e4dfab6ffde51" => :high_sierra
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
