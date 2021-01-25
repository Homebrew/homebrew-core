class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 5

  bottle do
    cellar :any
    sha256 "6871f0020f1714438013b8a9b7095ade712efdbf83f6a021e6aab84dcf9c7e02" => :big_sur
    sha256 "f3f1008133df0ebe53fc403c23f1356a2cf64f40a63650b3d9556b9f6f5e8ca2" => :arm64_big_sur
    sha256 "8e67e268c5328f4abc244177219ecacf13bed6a486952031de7a0ee133cb96e0" => :catalina
    sha256 "c06152ecd0c64e8f5a52e78d22cd46ce27f8e88e4ad929b5664eeed3fb7a4da9" => :mojave
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
