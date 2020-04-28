class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.13.1.tar.gz"
  sha256 "c8725d78e43b7d6a04465e8a156bc4c6a78121f291aac74e0b0a10286ef95544"
  revision 5

  bottle do
    cellar :any
    sha256 "e5807978fae3bbfe1bd7e9824a38ca7186e5a9a551b6684102837c660116c426" => :catalina
    sha256 "4ad28a929467ff6e45e67ebea05ec51e0eefe601e40b1224c760e87e7819b253" => :mojave
    sha256 "d229455ca4d76f80501d4c21cfb6dc5d48fc960e751df0fefa04d74cf715fcf3" => :high_sierra
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
