class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 16

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "227d9c3807dd77e231d61636683f51b656b04966b5e36bc137c58df35d52230e"
    sha256 cellar: :any,                 arm64_ventura:  "c1aeadaa563133053a09851b9423dd09a4d79eaa1e28f65ebdff21847f1d7f0e"
    sha256 cellar: :any,                 arm64_monterey: "e63785c74d313bc1c4c8c92eb01bb9ec64f12914849d53b94f12f18a8b2e1c47"
    sha256 cellar: :any,                 sonoma:         "cc075bf773ee919b496a3b6884c85c9ee21bb156ee5aae49ccdec2926884b531"
    sha256 cellar: :any,                 ventura:        "e37f57b03832b091538d658e5e87bc2274f12bb80c4e834a7b108171372e34ca"
    sha256 cellar: :any,                 monterey:       "8545109b7ddb2a27847df476137b24c66830d869fc869811b6b0934edd5dd2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b66d17be67cc0dd12fd6f412664f4db59d891f4460890ba6fc7e8d08e36a6a0"
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
