class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 15

  bottle do
    cellar :any
    sha256 "4d42db92aaa091045dde4d54fd1727ae6fd16a483b17060fc3a64f0dd3046be7" => :high_sierra
    sha256 "af3ac9f4dc6ab2e4dd1cfcb1dc92d970060f13150b0304c7fd98afbd4bedb5ba" => :sierra
    sha256 "925d5691450adb4438cd0a83309306fb527a88dcbd283456e822642151b361e3" => :el_capitan
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
