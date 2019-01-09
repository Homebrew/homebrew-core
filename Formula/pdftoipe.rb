class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.8.1.tar.gz"
  sha256 "a6174aae72f93b56c6652c2c27d5203e0f867e11a5e1c7d89c4aa3b4bcb67eb3"

  bottle do
    cellar :any
    sha256 "2cd13ac9063043b72ea31baa4c4e63d0f01f7c6de3faeb60821ccb5124b1ffe8" => :mojave
    sha256 "9f7850617867ea47cac86555fbf8bf362d257b3211386dafc1e19b032bf4b844" => :high_sierra
    sha256 "31c078371293d68ea288904c96bf253aba41da48194f7f367b0264bc85b26018" => :sierra
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
