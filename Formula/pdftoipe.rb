class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d4a4a339129c735f3678409ba65df389537fe0bbc1815cd00f45a3e95d226cbf"
    sha256 cellar: :any, big_sur:       "4db0d0f6861ad5b68884fe1018ddffd34b91e87b6e50b717eb703f6df8755de6"
    sha256 cellar: :any, catalina:      "c8af4fbd85098a565262c32ef5b4f2f77857891c19786fa30b82116c5f8143a3"
    sha256 cellar: :any, mojave:        "524dba1baa103aff93097672fe96e59f0a2998d67c548b1f579af3aa5ddc78c9"
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

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
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
