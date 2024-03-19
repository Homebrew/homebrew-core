class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 19

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b88ac0a1188d2370b2207d515836d79aae19dd7694edd9f5ab5b5cb82433f926"
    sha256 cellar: :any,                 arm64_ventura:  "dfecfa55237fb05bfaec55c8927513bac89c974bf0686a09823055b2a9d50035"
    sha256 cellar: :any,                 arm64_monterey: "9f23632de98c265639a7be060d846f5d9d3e58db43b6ad880041ece4bfcc916b"
    sha256 cellar: :any,                 sonoma:         "f7b33e16b80840ae730a4e03a9a9ee4ae6a714a6ecc7db78896488530da27035"
    sha256 cellar: :any,                 ventura:        "be84c146ae7093b96a8c34587c9d8e7a0b15dadda6be2253256788dab3e379ed"
    sha256 cellar: :any,                 monterey:       "285180cb8c024bbb56187e932928667b1aa55e364cb5cd5f775a4b43ea5f3550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "142e1254b96d49d21bfab29d06b9b83b5543e71e3b9aad78111f4fb196fe381d"
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
