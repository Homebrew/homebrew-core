class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.24.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.24.1.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-0.24.1.tar.gz"
  sha256 "7387ec048971a1b42c0aab866c51222f63af3cf51938695f555609c33d89e486"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "9b68ab2699f7d84774dec9f6940ad2fa1d318b908d0e3a426c22eba2c7618585"
    sha256 arm64_sonoma:  "3da16d62499cd1188ff24bac157c87b127a006f280f1f007f0f43504b0578ee2"
    sha256 arm64_ventura: "9787f37d392f6c5d9295ff993575924c1a840c4d949b9bb23643b30ec328dab7"
    sha256 sonoma:        "ed640edbc9fe2444c4d178a182fdff0f318aae9c9f05b0e6945801cf94ec7605"
    sha256 ventura:       "b80f024564436b534a6aa65d01efbb977441a9238196d767dc858068d66fd7e8"
    sha256 arm64_linux:   "4eec5148f1938085006d6dde7cfd22bffbfc288aaf4dba4dd874219619a65d42"
    sha256 x86_64_linux:  "f4218be546b32da338235b35633cbedbb4e315ef83b2222d345fb85f74fa4cb7"
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
