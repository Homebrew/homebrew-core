class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 1

  bottle do
    cellar :any
    sha256 "a4a4b89e10697160e7387ce7344c7e36e4188174460a4625c7d55d0c02aca506" => :sierra
    sha256 "98a06d5e74f9a06f38b0b668c2e5424ed4f578c39ff46c441a4c8edc102d2b3c" => :el_capitan
    sha256 "2ba3b2094292ea988a35d3c75fcb6e03e268e49fafe9ab6e201c818d61520184" => :yosemite
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
