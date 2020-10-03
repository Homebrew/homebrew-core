class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    cellar :any
    sha256 "2da5d6c4fb60ef9368920736a8c2892e2c877a4e4f2bbca6333312cb48f8dbb0" => :catalina
    sha256 "384eac41ae723a0dda928c61ad5eef6a1eb18f6c70ae106d45a3f5a493c35f82" => :mojave
    sha256 "8c1da079c97c63f3f5c6f5ded98d3b039ae146b2322685c62024bdf99d82b3a6" => :high_sierra
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
