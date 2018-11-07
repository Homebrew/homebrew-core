class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.2.tar.gz"
  sha256 "c56d86a0aafec490db250555bb795dd5d0f8b3db59a259da4f7d229f15f85c6e"

  bottle do
    cellar :any
    sha256 "8e56d6d43e12ba445bf1dcd908a79f31be8b75e6966ee522a967ab529600171a" => :mojave
    sha256 "678b001f6d06fe5b026eaa64d6365077fa7abefa3ad1247b2f9ae5b63b9c84bb" => :high_sierra
    sha256 "47d1ee72a76785961b3265cceea48b5f6ea874e62e7a332912e0e2b3e8a7f8a1" => :sierra
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
