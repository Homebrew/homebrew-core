class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "89bdc7d7cf94348a8e37fd8bf848b6584c06fa06253d616f65645946ba95d824"
    sha256 cellar: :any,                 arm64_monterey: "67e60fd70b646bfee7f712201342ee3525fe4ff0deccb886f090d2d4affc7210"
    sha256 cellar: :any,                 arm64_big_sur:  "35533b40392914bc8eb499664229805a122009a29ac1126654ecc97f4226a466"
    sha256 cellar: :any,                 ventura:        "e6cdd50b02c6a806c1edb151234a3b5353b48a0dd5f36cd22f4d3c0c9e48203c"
    sha256 cellar: :any,                 monterey:       "b665c9d20c474c2edeabb5106c2fe84ca608196f5f267dcae731585a70e47362"
    sha256 cellar: :any,                 big_sur:        "75fa2e1ca5154dce02791b194a2feee0884dcd5191c1dffc547df1ddb36ad234"
    sha256 cellar: :any,                 catalina:       "379925a0153ff09be01d80b95522f1ded4282f79f72e5a943c381d0998d6376c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe3470214a14f4bbce7e8b1aa8b53c74808c8d57af82a8ed9513e74e3aa25f4a"
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
