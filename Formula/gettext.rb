class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.21.tar.xz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.21.tar.xz"
  sha256 "d20fcbb537e02dcf1383197ba05bd0734ef7bf5db06bdb241eb69b7d16b73192"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "a025e143fe3f5f7e24a936b8b0a4926acfdd025b11d62024e3d355c106536d56" => :big_sur
    sha256 "339b62b52ba86dfa73091d37341104b46c01ae354ca425000732df689305442b" => :arm64_big_sur
    sha256 "cdea54f52b7c36ebcb5fe26a1cf736d7cd6fd5f2fd016dd8357a8624ffd6b5f8" => :catalina
    sha256 "99707d4dcc731faf980333365a694e9500f2f012f84c0bcb6d8cb5d620c2ce08" => :mojave
    sha256 "5ac5783e31205b92907b46bfaaa142620aea7ee3fc4d996876b0913fd2315695" => :high_sierra
  end

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--disable-debug",
      "--prefix=#{prefix}",
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
    on_macos do
      # Ship libintl.h. Disabled on linux as libintl.h is provided by glibc
      # https://gcc-help.gcc.gnu.narkive.com/CYebbZqg/cc1-undefined-reference-to-libintl-textdomain
      # There should never be a need to install gettext's libintl.h on
      # GNU/Linux systems using glibc. If you have it installed you've borked
      # your system somehow.
      args << "--with-included-gettext"
    end
    on_linux do
      args << "--with-libxml2-prefix=#{Formula["libxml2"].opt_prefix}"
    end
    system "./configure", *args
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end

  test do
    system bin/"gettext", "test"
  end
end
