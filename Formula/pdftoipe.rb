class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 14

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a3ff2d20ea45dc43f3b58de160a2d4e587d869a7868f3a1b6145460663a35f31"
    sha256 cellar: :any,                 arm64_monterey: "84596934f765613563fa4198943097556bcd37386bb7137e9c96fc1c6607f80f"
    sha256 cellar: :any,                 arm64_big_sur:  "2d794bd8c5da054a6b46478411d7e6756cc26642e0df9bed87dce5d26a69bf64"
    sha256 cellar: :any,                 ventura:        "7e24d7cc7ebb2c80d575fa0a9891e7304fe9bb2d8cec46e2637586c6898f0eb1"
    sha256 cellar: :any,                 monterey:       "6d1c641e4cb565deb4fef6bc92d015f12bcea5ae2652e6563107dccf5a73a974"
    sha256 cellar: :any,                 big_sur:        "4fbe620ef039ff3a38c3de822234c5190d18c11507cc71dde9e763541a8c707f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "607738a3b3b55518ed81b0a4542a1e9f39d703aa0a678ce1ee61d27a1d520f96"
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  fails_with gcc: "5"

  # https://github.com/otfried/ipe-tools/pull/48
  patch do
    url "https://github.com/otfried/ipe-tools/commit/14335180432152ad094300d0afd00d8e390469b2.patch?full_index=1"
    sha256 "544d891bfab2c297f659895761cb296d6ed2b4aa76a888e9ca2c215d497a48e5"
  end

  # https://github.com/otfried/ipe-tools/pull/55
  patch do
    url "https://github.com/otfried/ipe-tools/commit/65586fcd9cc39e482ae5a9abdb6f4932d9bb88c4.patch?full_index=1"
    sha256 "61f507fcaa843c00e5aa06bc1c8ab1cbc2798214c5f794d2c9bd376f78b49a11"
  end

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
