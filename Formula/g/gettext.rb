class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.23.tar.gz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.23.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-0.23.tar.gz"
  sha256 "945dd7002a02dd7108ad0510602e13416b41d327898cf8522201bc6af10907a6"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "9ad2a8e2fff717a18460818d086c02b8ed9f4c42a853f41a88c6f9b601b36615"
    sha256 arm64_sonoma:  "7cf6084ae306256b1df18c8d75ba63abeccd5c605cfc8406dab8c09d98815bc1"
    sha256 arm64_ventura: "3ead4ac2832bf1fbf02a5d1e8cdac9f0b46957615215d42382a85c4cf0f32aa0"
    sha256 sonoma:        "1bb442e6a65a0d7930a5cfcee44e8e3c4a41ff99351535cce6101b32ce723706"
    sha256 ventura:       "668023b6002ad5f2aca0e78a0d33ec8a24a660f82149b95cd42d14008dd59d2a"
    sha256 x86_64_linux:  "c1a3a97412d28be6552c4b4191c174ce145329b165599c280b550f9a54bed9b8"
  end

  depends_on "libunistring"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "acl"
  end

  def install
    # macOS iconv implementation is slightly broken since Sonoma.
    # This is also why we skip `make check`.
    # upstream bug report, https://savannah.gnu.org/bugs/index.php?66541
    ENV["am_cv_func_iconv_works"] = "yes" if OS.mac? && MacOS.version == :sequoia

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
