class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.13.1.tar.gz"
  sha256 "c8725d78e43b7d6a04465e8a156bc4c6a78121f291aac74e0b0a10286ef95544"
  revision 6

  bottle do
    cellar :any
    sha256 "12129890395da43739486b55696d72d94397ecdb7bbbcd030cf28729b16dbb86" => :catalina
    sha256 "095bf612b17d5232645d7f90754ab8f06b167111bb981a5b21e50182c022be6e" => :mojave
    sha256 "7d902587f26a88dc55e77f7cfb132b984d82550d3075d7d934cf0a91dd523d45" => :high_sierra
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
