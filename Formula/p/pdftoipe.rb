class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "923b526a2e4698aa981e22e75b45f4cef28353a3f7edf7eb0dcd62b9096f57f8"
    sha256 cellar: :any,                 arm64_sonoma:  "47c794887f692cd3f0bc784de6a985285f97cf20eee461777424a98b3720aba6"
    sha256 cellar: :any,                 arm64_ventura: "f3715786faae7a6b07ae1d83e0737f4a91a4c13d4cf1990a46a801c64b3f2d45"
    sha256 cellar: :any,                 sonoma:        "dd17a18a685239ab3e2bef060ceef61ad0cc9baa28de84612e7bbd5385536064"
    sha256 cellar: :any,                 ventura:       "0d4f281b71d14c559213124d3e6c5b720eca03b985cf59d5fa38a37a85b782ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c79c4f61f598efbe817320334b7c7b9ef6c61c5ee50d185480d917cb880fd76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0339cdc011f5deff1acd27a39ab35cdd15d84c42493eb8008f6b86ba2dd44dcd"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  def install
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
