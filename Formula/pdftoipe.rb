class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.8.1.tar.gz"
  sha256 "a6174aae72f93b56c6652c2c27d5203e0f867e11a5e1c7d89c4aa3b4bcb67eb3"
  revision 1

  bottle do
    cellar :any
    sha256 "3110a084264ec6dd38810263fa6d6fb6bec59084f4b22c4a482e0b8cb64947af" => :mojave
    sha256 "ef5274b9a20845c5efd8f7115fbde565d52a10ae1ce877893d38126ae66f2c41" => :high_sierra
    sha256 "caa986e18c5baa5baa7bae675edf15841b21c26f476c4072b39ce5b7c66eaf5f" => :sierra
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
