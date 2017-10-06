class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 6

  bottle do
    cellar :any
    sha256 "e73279630e3f78e02a30bf50cf3e45e7c2c8d4cda9e666b11e7e015cbed2584f" => :high_sierra
    sha256 "97f47ec973b07866cc87be02a79f7988583bc7f70b9653729359c5becebcd05a" => :sierra
    sha256 "01885e1627554ffc6b098c78999d96a081844b14c0ad30b98d4407cceeca0cbf" => :el_capitan
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
