class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.8.1.tar.gz"
  sha256 "a6174aae72f93b56c6652c2c27d5203e0f867e11a5e1c7d89c4aa3b4bcb67eb3"
  revision 6

  bottle do
    cellar :any
    sha256 "cfb9b5d496726167cb9fe0837df5921add490392e57d2b9263a6eee1da01ff93" => :mojave
    sha256 "af435a43bfbb07dce1602f6d10fc2708917be981b9d6bc83ee12c9ddac290e4a" => :high_sierra
    sha256 "58d3f7c01a1a3f561b35cee63a2c752610b9dea1099ed6e6885d5c7cb4c01416" => :sierra
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
    assert_match "Homebrew test.</text>", File.read("test.ipe")
  end
end
