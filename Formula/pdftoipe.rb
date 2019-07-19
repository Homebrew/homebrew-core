class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.8.1.tar.gz"
  sha256 "a6174aae72f93b56c6652c2c27d5203e0f867e11a5e1c7d89c4aa3b4bcb67eb3"
  revision 5

  bottle do
    cellar :any
    sha256 "3ec1257337111604ff8f5d586d1da9e446cc07faf45f317058999301fabb6edb" => :mojave
    sha256 "194e5b57f4f9cecd117a0a772205937305e5a0e168393c3d3a82ac9c0d9aa25c" => :high_sierra
    sha256 "8dde953e682d7ac06ff3d3cfa1e60379442b9fbe5401756a26b9da92336080a4" => :sierra
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
