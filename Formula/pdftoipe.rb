class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 14

  bottle do
    cellar :any
    sha256 "91cbd92c5f366c3cd1d8608a35545247355d3b6e3ca88d07cbb4163977ffc3bf" => :high_sierra
    sha256 "a328512068c79e9505d679722c74e3109f5e13094010a6dc6d4b10f6f7a0d7fe" => :sierra
    sha256 "555ddedf21b3fbdd41b68692cbb293bc81a7b42fe5deb575d76662a813569b98" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  needs :cxx11

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
