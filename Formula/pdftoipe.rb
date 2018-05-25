class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 12

  bottle do
    cellar :any
    sha256 "4ea7575139a3e511f32c0edcbb64996e03066bad38a7fa1c92c3a1f307e2dafb" => :high_sierra
    sha256 "e99966e1c73ee338be64e4b68a772d579bbfa60aa77807ad1be666c97831f6bf" => :sierra
    sha256 "f590a8c5c45e18387f91b0a7594e1b98f99b9920b062772d91c53e20c1cc47c6" => :el_capitan
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
