class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 1

  bottle do
    cellar :any
    sha256 "d24959adb48c689e98ce9538df703f736c70fe02da6e456711191c39457fd48e" => :sierra
    sha256 "de224b1e96f9ac3756fa201169d347e4512a21cfe3a6105489ef24f821ae9e44" => :el_capitan
    sha256 "e5c6c123552838e0fce75c06045091ac040d930dc345ea84d3d0eaacc5db97bf" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
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
