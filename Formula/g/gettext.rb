class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.22.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.22.3.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-0.22.3.tar.gz"
  sha256 "839a260b2314ba66274dae7d245ec19fce190a3aa67869bf31354cb558df42c7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "287240f844318fe88193b706d6e07121b2cc7cfb3b5e2f47e21ee6970ffceb09"
    sha256 arm64_ventura:  "9bf5b0ea5fb893fe294c2c5f9195026e082e84e4dce24c81b544f62d9d85dd02"
    sha256 arm64_monterey: "29b5bf933d4cc986e2f7b580d11aee8b755f5fab5621bd955dd3ca6867922e10"
    sha256 sonoma:         "1853891cc14ff16ab102dd75b8ee313975bfdb17c03737975ca61b5a05159e5a"
    sha256 ventura:        "6971461fbd5d738e7f5609ced872ff87b88a4425c7ba42450871abe743178574"
    sha256 monterey:       "3600ef54a17fc9782a367a70d60a3996eae4613075ba05e8943cb1e5190d35fc"
    sha256 x86_64_linux:   "173e5e5fac30885db41e894d9b46798e3023b1543f2d855eaaf77e99e6ed3ddd"
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
