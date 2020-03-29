class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.13.1.tar.gz"
  sha256 "c8725d78e43b7d6a04465e8a156bc4c6a78121f291aac74e0b0a10286ef95544"
  revision 3

  bottle do
    cellar :any
    sha256 "bbb68ec7f0fe62087eb24f2b559f220ebb2acf4dc0de167059df30098abfaa61" => :catalina
    sha256 "e278036d842dd6f895eb40017348c94b0f1ef3b90910e2d570056a48a6d989b6" => :mojave
    sha256 "739071d2b36167c045731f867907dbaddacc0f9d859f1366dfb8419d63b23c94" => :high_sierra
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
