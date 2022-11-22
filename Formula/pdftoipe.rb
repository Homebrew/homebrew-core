class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 8

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "347e260c84772478c2766f72ce4cdcf3bbae124da26de9b955800f5f68967325"
    sha256 cellar: :any,                 arm64_monterey: "49b6d7edc992d6c19211ce2f488d1a355c616878a26ba3742921f113f407ae68"
    sha256 cellar: :any,                 arm64_big_sur:  "33571148c756d8730fc004937ca8d5a30a2d4b9275313de195d818adab327c23"
    sha256 cellar: :any,                 ventura:        "a1eaffcab51cf0edccdaf6caaff37e0b604622843bf29d67bf9f12248c9ed3f2"
    sha256 cellar: :any,                 monterey:       "6289d86a47fd870d5620dd45109740a8617ef8f3dc5035e198c925bf8ef67262"
    sha256 cellar: :any,                 big_sur:        "01d90eeedd36b5554dd343d1601bda4e5cab4a3ef0b3ae758c7934cf230dc0d8"
    sha256 cellar: :any,                 catalina:       "f49a56d0649e05fc10da4da42b0ea0ed8b54756b43117a713119176cdb5da368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53982c2c0722d7f79dd2b06d8f74e0703e8f4b92cd5cfcbd260b94e40d9c5b8b"
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
