class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 18

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b1ba8c8b3d670015b0bd005e31a7d01f37e5079ec6599e395530c2a97996b69d"
    sha256 cellar: :any,                 arm64_ventura:  "5576c9beaf8dd3de47764d3aa4b4d869a3c0df3469c8134470d91a07d5e82454"
    sha256 cellar: :any,                 arm64_monterey: "6e8a613b19b07c2cf67c5acd0a8a7cac02b700a28a8b9ac0c3cefe115f0e7b4f"
    sha256 cellar: :any,                 sonoma:         "7a30e10d06602784f65e17c52804e568d07e56ee42b1b64dbda0578c16023b36"
    sha256 cellar: :any,                 ventura:        "7225ffeed54dbada75850dc3b00402738a2fac5865496addbeb660091ecd7b9c"
    sha256 cellar: :any,                 monterey:       "1762a3ac395beafc50baa391a1f9dfead8f47dccf17a9396bc06925adf6d708d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4575f48b470bf7fcff3e2be0f68351f0f75c6db809498f9528d97ba5012d0df8"
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
