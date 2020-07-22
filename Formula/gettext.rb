class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.20.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.20.2.tar.xz"
  sha256 "b22b818e644c37f6e3d1643a1943c32c3a9bff726d601e53047d2682019ceaba"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 "71f4ded03e8258b5e6896eebb00d26ed48307fbebece1a884b17ca3fb40e3121" => :catalina
    sha256 "52067198cab528f05fdc0b06f7b9711f7614f60a7361f1e764c4f46d3342ff22" => :mojave
    sha256 "4a999c75dcc53cbc711e3ac6545db69ab3aeca6c29c1cb6b21c353f237342457" => :high_sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-included-gettext",
                          # Work around a gnulib issue with macOS Catalina
                          "gl_cv_func_ftello_works=yes",
                          "--with-included-glib",
                          "--with-included-libcroco",
                          "--with-included-libunistring",
                          "--with-emacs",
                          "--with-lispdir=#{elisp}",
                          "--disable-java",
                          "--disable-csharp",
                          # Don't use VCS systems to create these archives
                          "--without-git",
                          "--without-cvs",
                          "--without-xz"
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end

  test do
    system bin/"gettext", "test"
  end
end
