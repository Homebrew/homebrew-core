class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftpmirror.gnu.org/gnu/gettext/gettext-1.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-1.0.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-1.0.tar.gz"
  sha256 "85d99b79c981a404874c02e0342176cf75c7698e2b51fe41031cf6526d974f1a"
  license all_of: [
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later", # libintl, libasprintf
  ]

  bottle do
    sha256 arm64_tahoe:   "1f98400343132c8e469ed475157f8f4d0f516ea86bd4600552e8b75ab638fcf9"
    sha256 arm64_sequoia: "982f3a3cc24df4f552efc1b6ed6303d2920b2d5b1c1975fe3d9bd7418b8fa532"
    sha256 arm64_sonoma:  "f9ea4eed738746ea4150a4f83e8dd11ca21ca3de5bb113995c25eec409bb5749"
    sha256 sonoma:        "2cc112cce103be3beb13cc8ba67f521d4e972c4082fd69868d34920d63120c09"
    sha256 arm64_linux:   "0d24ef468ab6683610fb866973cbdf899165be653b42c68689b70743be5ce695"
    sha256 x86_64_linux:  "ed30be09f5f328a974e51e34966a502496e0623c7ecde0faf7559143cbd02255"
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
