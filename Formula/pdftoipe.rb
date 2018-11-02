class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.2.tar.gz"
  sha256 "c56d86a0aafec490db250555bb795dd5d0f8b3db59a259da4f7d229f15f85c6e"

  bottle do
    cellar :any
    sha256 "32f3eb23cd382132802c096d9f478e91d932a9ffed3c18f4626126da7b240c96" => :mojave
    sha256 "2c34d9f940e9889039d6b3e3c8a749b2c4572b9f2a8bd7e98a0a4316cefedcab" => :high_sierra
    sha256 "038ad5e7c7ba1aaa2850b42014d03fecf22aa5aec78845db40a6bbc5bc5f8419" => :sierra
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
