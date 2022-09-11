class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2d556cb2378d929c1d4140cda205345b2345d29f7d2469999b38dd58a054fb73"
    sha256 cellar: :any,                 arm64_big_sur:  "f428c1107d16442bba6abfc68093f5d1cb4c39a535b5354a5689f7923c958a11"
    sha256 cellar: :any,                 monterey:       "a85cbf34a628f403191e586fae328acc6f94125f83d62d7a2feca243ec7e2fce"
    sha256 cellar: :any,                 big_sur:        "37f090f0f9ed6042152e23d2ff42204bae6d2844d07b65e0a4bf2fd38a04a135"
    sha256 cellar: :any,                 catalina:       "127fb0d5b14baa3c10742426436ece48ed87630822f69ced0ac4c32c1981ca12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41689d4506af5cd556674f6a0b2249270b54789970aa0b6b0fb8f78d891d304b"
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  fails_with gcc: "5"

  # https://github.com/otfried/ipe-tools/pull/48
  patch do
    url "https://github.com/otfried/ipe-tools/commit/14335180432152ad094300d0afd00d8e390469b2.patch?full_index=1"
    sha256 "544d891bfab2c297f659895761cb296d6ed2b4aa76a888e9ca2c215d497a48e5"
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
