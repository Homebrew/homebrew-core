class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.8.1.tar.gz"
  sha256 "a6174aae72f93b56c6652c2c27d5203e0f867e11a5e1c7d89c4aa3b4bcb67eb3"
  revision 5

  bottle do
    cellar :any
    sha256 "a27d7d1c991dd6d38384eb72c8e6738b37d073eae111f6b8ecc0de659dc1ad64" => :mojave
    sha256 "4b8f5e7638f7a72a4a1eac021135e54225a4621aebbe9b95916a354b7c5636ad" => :high_sierra
    sha256 "4c8e877c2143a05d060eab21d51612e60ed893127ebe9a03eb70aa38c44a85d1" => :sierra
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
