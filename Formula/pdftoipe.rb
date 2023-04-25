class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d484b6330a6291a8a0efb54c8c28a3fa20be62d8a20b29b0c0eece5a45c0f42"
    sha256 cellar: :any,                 arm64_monterey: "d7060a1aad469fdbddc75dc2ba131c7b4e55079cdee15e310903194ee0791b5d"
    sha256 cellar: :any,                 arm64_big_sur:  "d69a8d67e91a4d91b29cafdbd14baab245c08c91cbdf36133c5b471e09469d8a"
    sha256 cellar: :any,                 ventura:        "ba6b5fc0dd765fdb980104cb47dc100f583e35174a68c840f3dea81e07e627d2"
    sha256 cellar: :any,                 monterey:       "d6fdfa2d4ebe8c48772d3d8e1f7c014f6596d0c5906e70498bac9967f92d3064"
    sha256 cellar: :any,                 big_sur:        "ccb790391601f6cf58eb081311d6db41b05dcc0506ebe886919c51f56a29f1bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef56d5b29e11ddb5e56512afb87ad60c79a0a4f8b55917cc4b7b1a87cd481d59"
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
