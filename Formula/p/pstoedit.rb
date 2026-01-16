class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://github.com/woglu/pstoedit/archive/refs/tags/v4.3.tar.gz"
  sha256 "36dfdc79c750930dd57e2c4a4dee2a6ab1a1fe65cd8fc4dc047dbfb6f2cfa15b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "ec621b279a29d7d40d7b5a0be2c1f3bb670afa6db0db269421b5f5bf65c984b3"
    sha256 arm64_sequoia: "042b5b95fe959b9e09d4e407a3502f8be31239b012295c1aa7a070682e405a7e"
    sha256 arm64_sonoma:  "1c949cb1b0dd899c1b70db1bf662d288c0cb3173facb72bd74483399a709c0b4"
    sha256 sonoma:        "04eede4a48448503f79ab9a9a52d23982f956bf315a31147dc90d29332b4bea8"
    sha256 arm64_linux:   "1c23ba09ab213722081cae59fe165f8bad1af2f3f8d26d950c11f55ba309eb9b"
    sha256 x86_64_linux:  "ccbe027ead36fd375a176f7631bbccfdd2268277c16b21f22eb9900d43f1fec4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "gd"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "plotutils"

  def install
    # Workaround for windows only header `io.h`
    inreplace "src/drvsvg.cpp", "#include <io.h>", "#include <unistd.h>\n#include <fcntl.h>"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--enable-docs=no", *std_configure_args

    # The GitHub release tarball does not ship the generated manpage (pstoedit.1),
    # so building the doc/ subdir fails. Build/install only src/.
    system "make", "-C", "src", "install"
  end

  test do
    system bin/"pstoedit", "-f", "gs:pdfwrite", test_fixtures("test.ps"), "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
