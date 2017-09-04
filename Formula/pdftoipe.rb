class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 3

  bottle do
    cellar :any
    sha256 "c04cd058c0be0948bdf52fe14529128193ef3fc2902102f1ff6c92db9b4909c6" => :sierra
    sha256 "243cead9169d5d916c2c14644e0841eb8750b858bbc2f17f58cbb3c6666c75be" => :el_capitan
    sha256 "9185561cf9f59e21a81d34d88063b66cd44ad1b9121b6cb1d96d37293821c5f9" => :yosemite
  end

  depends_on "pkg-config" => :build

  # Upstream issue "poppler 0.59.0 incompatibility"
  # Reported 4 Sep 2017 https://github.com/otfried/ipe-tools/issues/27
  depends_on "poppler@0.57"

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
