class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 10

  bottle do
    cellar :any
    sha256 "7d93074c6563f9bc4911bb8edc2b756af1ee7cd1cc7c437d3585fa9e5e4176d8" => :high_sierra
    sha256 "a8b9cbceaae3a4e6231152f2b17a5a11f1b5efda2044a2e791a88ed592200159" => :sierra
    sha256 "7b1c1c9b64e5a350374933c1b9875791c9ab38843167d53e8a15e0554ec19f3a" => :el_capitan
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
