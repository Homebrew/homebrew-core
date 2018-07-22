class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 14

  bottle do
    cellar :any
    sha256 "b350eb1de61baa0c49e650818ab749de7dee8b3173900fd65934ac6fce64bf68" => :high_sierra
    sha256 "e0660fd4bf7e0f07419c012d463853cc6d74f2874f38d52ebe19763c76b67704" => :sierra
    sha256 "dbb6774abbe6145151f09a75bd210835f26093d8bbc5f6341a05eee515d27b5e" => :el_capitan
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
