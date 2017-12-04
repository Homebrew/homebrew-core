class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 8

  bottle do
    cellar :any
    sha256 "058185dafa3bedff54fe21112a458e7f645690e726849bcdc9f098fcd78047f8" => :high_sierra
    sha256 "07337bb70723db07caf055d766301e6c9561650f033e9fb68f24d5c81863fb4a" => :sierra
    sha256 "7db25ccabccbd082d93cebe98f566a29e59386bf343e113e80842b21dcb4f6ee" => :el_capitan
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
