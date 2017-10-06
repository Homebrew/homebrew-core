class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 6

  bottle do
    cellar :any
    sha256 "4297507bef3b13975118ddecbfcf9bf3dfd095fbea26cfef804acb05a13b148d" => :high_sierra
    sha256 "01677cbdc5a359db81b0e55726af5f27a7e03025470bc7cb0a4e2b8ab382441b" => :sierra
    sha256 "315460aeba084711794f89a7c67b7242b80fc628f7128c0c920dfa84aa0872ba" => :el_capitan
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
