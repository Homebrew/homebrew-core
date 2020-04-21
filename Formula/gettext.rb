class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.20.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.20.2.tar.xz"
  sha256 "b22b818e644c37f6e3d1643a1943c32c3a9bff726d601e53047d2682019ceaba"
  revision 1

  bottle do
    sha256 "90adf1ef48f8ba71c73b03db871551b5ff3e9704ce6fe5d6532df0056223de80" => :catalina
    sha256 "f79ca95c2216e5b599d57f96fe99081af8780c31bd013f60c296bc7d3800845a" => :mojave
    sha256 "f6248b134438427eec73cbe099fb19dc20dbce1119d02b23ec7a0c8f0f34da7e" => :high_sierra
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
