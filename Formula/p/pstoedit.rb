class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://github.com/woglu/pstoedit/archive/refs/tags/v4.3.tar.gz"
  sha256 "36dfdc79c750930dd57e2c4a4dee2a6ab1a1fe65cd8fc4dc047dbfb6f2cfa15b"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "71b16f3464e1314670842c663a4cfee626a740a6bc39f7ea6219cb7f21329fee"
    sha256 arm64_sequoia: "fff1ed2e7e57c3852c5fe36c3908938d19ec278a852e1aa8ef48cc2a175c747c"
    sha256 arm64_sonoma:  "2e0dd4ee1aeeb14214e8c313d0cbaceb1c2f0b89abb67ac6e56d1a23335ad9b3"
    sha256 sonoma:        "80cd866453569577436a25984e996e66d45b8cf0b719c771bc25da182d92342d"
    sha256 arm64_linux:   "c68b2fe60978946380b35dc59bf333c260dab5ac1fe3c6c17f75f4c6fbf52eb6"
    sha256 x86_64_linux:  "9e40b2f416da1059d432772976a9782362d5911680ca6026c1af161ce9bc462e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "gd"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "libzip"
  depends_on "plotutils"

  def install
    # Workaround for windows only header `io.h`
    inreplace "src/drvsvg.cpp", "#include <io.h>", "#include <unistd.h>\n#include <fcntl.h>"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--enable-docs=no", *std_configure_args

    # The GitHub release tarball does not ship the generated manpage (pstoedit.1),
    # so building the doc/ subdir fails. Build/install only src/ and config/.
    system "make", "-C", "src", "install"
    system "make", "-C", "config", "install"
  end

  test do
    system bin/"pstoedit", "-f", "gs:pdfwrite", test_fixtures("test.ps"), "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
