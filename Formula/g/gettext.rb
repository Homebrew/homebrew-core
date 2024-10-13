class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.22.5.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz"
  sha256 "ec1705b1e969b83a9f073144ec806151db88127f5e40fe5a94cb6c8fa48996a0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "7f005ca74e89d423f7be79f4c5eb7b646a19de23c23c4ca09cbe68d18da4fe10"
    sha256 arm64_sonoma:   "4b5b6cb0692b4606b9220fcbc9da3ab546234348dc87ef8033830e22c4c7bdb1"
    sha256 arm64_ventura:  "06ee5992f8a7dbf85a1b0e4c6311029cefda6d70852e5abd28f2e8e30d27cfcf"
    sha256 arm64_monterey: "2707884e348a412db35279bdd713c9026c1b1cf40fcc67fc562e68b26189bb86"
    sha256 sonoma:         "13492dddf82cad8dcb20d1c6375138a0712ce8e3c25b612256672446175c9727"
    sha256 ventura:        "1a35820de97aa8d93019d64f7add5443bcf1c14f05bd249e670e7ca0f0fc6b2a"
    sha256 monterey:       "93211634913a6762dbf0e50dd644b9c932ec19124c4500f97228fbff80b0821c"
    sha256 x86_64_linux:   "11f57f3c216f3603a194fe96d22ee05b2d01fbbaeb4a0047ed43cee25d29f9aa"
  end

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    args = [
      "--disable-silent-rules",
      "--with-included-glib",
      "--with-included-libcroco",
      "--with-included-libunistring",
      "--with-included-libxml",
      "--with-emacs",
      "--with-lispdir=#{elisp}",
      "--disable-java",
      "--disable-csharp",
      # Don't use VCS systems to create these archives
      "--without-git",
      "--without-cvs",
      "--without-xz",
    ]
    args << if OS.mac?
      # Ship libintl.h. Disabled on linux as libintl.h is provided by glibc
      # https://gcc-help.gcc.gnu.narkive.com/CYebbZqg/cc1-undefined-reference-to-libintl-textdomain
      # There should never be a need to install gettext's libintl.h on
      # GNU/Linux systems using glibc. If you have it installed you've borked
      # your system somehow.
      "--with-included-gettext"
    else
      "--with-libxml2-prefix=#{Formula["libxml2"].opt_prefix}"
    end

    system "./configure", *std_configure_args, *args
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end

  test do
    system bin/"gettext", "test"
  end
end
