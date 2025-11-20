class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftpmirror.gnu.org/gnu/gettext/gettext-0.26.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-0.26.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-0.26.tar.gz"
  sha256 "39acf4b0371e9b110b60005562aace5b3631fed9b1bb9ecccfc7f56e58bb1d7f"
  license all_of: [
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later", # libintl, libasprintf
  ]
  revision 1

  bottle do
    sha256 arm64_tahoe:   "ba9215fd5110a60cf544cbdf76536d5b7d198c73cad97c9552ebd54216312862"
    sha256 arm64_sequoia: "f1aa739f3f4b720b7abf4512af6d1c470feafe57b15ebca25c45f8b22afe7ab5"
    sha256 arm64_sonoma:  "cf146240f332843bd4eb21286f678e4625d46b49a635153f1f1eba926793ee55"
    sha256 sonoma:        "55a702b28d00815fb7dbd01f5d77059c84fcd65763e417a3b0a021a13481259e"
    sha256 arm64_linux:   "1bd1fd569c6caca916593563d720b3e10bc01144bc5920611c54b23f462f36b0"
    sha256 x86_64_linux:  "4107f2ed57956975c0af99807991d62372df69abcd9e8990757b8b22c3d7d766"
  end

  depends_on "libunistring"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "acl"
  end

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # macOS iconv implementation is slightly broken since Sonoma.
    # upstream bug report, https://savannah.gnu.org/bugs/index.php?66541
    ENV["am_cv_func_iconv_works"] = "yes" if OS.mac? && MacOS.version >= :sequoia

    args = [
      "--with-libunistring-prefix=#{Formula["libunistring"].opt_prefix}",
      "--disable-silent-rules",
      "--with-included-glib",
      "--with-included-libcroco",
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
