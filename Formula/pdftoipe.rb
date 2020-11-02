class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    cellar :any
    sha256 "dce844bc712aedd10e26a79cb040452a352be261879ffdbf180fbb1f4e454dd2" => :catalina
    sha256 "e4b7dfa4fe591975d76a67b227ec79f56fea8f8c08a2c2f4780c01b3a38faf92" => :mojave
    sha256 "22eceb01b3b141a947f5acc1f883279626b8331055a971a2fac905f36257cf10" => :high_sierra
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
