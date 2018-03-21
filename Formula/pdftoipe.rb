class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 10

  bottle do
    cellar :any
    sha256 "91d748472cfdcd5f5bc3076bd82231bad43f7aafd0c5bbbe9ff3bb0158c9b646" => :high_sierra
    sha256 "9604587482d98022d9e3f09e45c124f15a0e01da7ba582d043b136d3316b82aa" => :sierra
    sha256 "65363797147e598b7587a45698cc72bc1b1baddaf679e3423e05a75d2793a1a8" => :el_capitan
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
