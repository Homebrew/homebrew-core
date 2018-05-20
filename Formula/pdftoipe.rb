class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 12

  bottle do
    cellar :any
    sha256 "d770af375e7da8ea4eb4a138b828630fb71ff482382c7b519aa4e584e0a110ad" => :high_sierra
    sha256 "785d69dfcf0b2d7ed88b4b275f115eb930ca6faae31b16498a912b825daf6376" => :sierra
    sha256 "7c9157ee4f0c0c206a67fa8031f917907dee884d6f8f71113b5983b971314d68" => :el_capitan
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
