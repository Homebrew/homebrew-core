class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.8.1.tar.gz"
  sha256 "a6174aae72f93b56c6652c2c27d5203e0f867e11a5e1c7d89c4aa3b4bcb67eb3"
  revision 2

  bottle do
    cellar :any
    sha256 "bdcb4d2596562dd50d54b5d0b1398baabcc752ebb6c7975094a1f9983cb71e90" => :mojave
    sha256 "4e0e1f523ae8e3752f791fd7a62219a3098f92937130f23f74b96b032a52b7ae" => :high_sierra
    sha256 "92e4f1e06ad2dde3e269f99d0c1a76d82b7f8c919f4115d01f55558e72113337" => :sierra
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
    assert_match "Homebrew test.</text>", File.read("test.ipe")
  end
end
