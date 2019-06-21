class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.8.1.tar.gz"
  sha256 "a6174aae72f93b56c6652c2c27d5203e0f867e11a5e1c7d89c4aa3b4bcb67eb3"
  revision 4

  bottle do
    cellar :any
    sha256 "ec14e81afff2078babfc7ca3b37e9ffe50aa39e08360034710872768922d2883" => :mojave
    sha256 "9ab555ebc04d89c7656281bf678c4ba7ff0daf67f847834c7e4f301c4bacf3b6" => :high_sierra
    sha256 "2c8623b150dbd87575901037100b8a8964f3a5012e9156b3fa40f1556a210222" => :sierra
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
