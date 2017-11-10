class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  revision 2
  head "https://git.ghostscript.com/mupdf.git"

  stable do
    url "https://mupdf.com/downloads/mupdf-1.11-source.tar.gz"
    sha256 "209474a80c56a035ce3f4958a63373a96fad75c927c7b1acdc553fc85855f00a"

    # Upstream already. Remove on next stable release.
    patch do
      url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mupdf/mupdf_1.11+ds1-2.debian.tar.xz"
      mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mupdf/mupdf_1.11+ds1-2.debian.tar.xz"
      sha256 "da7445a8063d7c81b97d2c373aa112df69d3ad29989b67621387e88d9c38b668"
      apply "patches/0004-Fix-698539-Don-t-use-xps-font-if-it-could-not-be-loa.patch",
            "patches/0005-Fix-698540-Check-name-comment-and-meta-size-field-si.patch",
            "patches/0006-Fix-698558-Handle-non-tags-in-tag-name-comparisons.patch"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "94addefb7d39510f957626c19684981ca0d86e5455c6fe35d7c830b64f21e99d" => :high_sierra
    sha256 "910a059aef7e0726bea610e75288e7655916d58f4ba9727eda0b5f1c993e75f7" => :sierra
    sha256 "f1233228a7f33499ff4d5f3f3eb20d871c4146c760d9d4ecb01de9004248a0b3" => :el_capitan
  end

  def install
    # Work around bug: https://bugs.ghostscript.com/show_bug.cgi?id=697842
    inreplace "Makerules", "RANLIB_CMD := xcrun", "RANLIB_CMD = xcrun"

    # We're using an inreplace here because Debian's version of this patch
    # breaks when using Clang as a compiler rather than GCC. This fixes
    # CVE-2017-15587.
    if build.stable?
      inreplace "source/pdf/pdf-xref.c", "if (i0 < 0 || i1 < 0)",
                                         "if (i0 < 0 || i1 < 0 || i0 > INT_MAX - i1)"
    end

    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}",
           "HAVE_GLFW=no" # Do not build OpenGL viewer: https://bugs.ghostscript.com/show_bug.cgi?id=697842

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mutool draw -F txt #{test_fixtures("test.pdf")}")
  end
end
