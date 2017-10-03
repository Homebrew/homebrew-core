class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 5

  bottle do
    cellar :any
    sha256 "5cf54e79cb9053974f93ec62c0909dcf8b068d07a6c59410ba61354be5ebec0a" => :high_sierra
    sha256 "1a943c9cb3fee43e2bb820ad2dad09eecaae122e345a351e6f190fb3721e9a21" => :sierra
    sha256 "2e607ecf1fc1d85e89de739a8438ea5ba95223415e0419309574567af6ca3e24" => :el_capitan
    sha256 "7e43533bbf9ebf201e1c8d4caa5de618960a27872850c2ca52a34b760f574aa5" => :yosemite
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
