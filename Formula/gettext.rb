class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.20.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.20.1.tar.xz"
  sha256 "53f02fbbec9e798b0faaf7c73272f83608e835c6288dd58be6c9bb54624a3800"

  bottle do
    sha256 "107d7f386fbeea6979f9376cdbbcf3f60943caaad61bdc754d3019ce625dffe6" => :catalina
    sha256 "fa2096f80238b8f4d9f3724d526626ab4db5c0586f3746ee13fc66e5a625aa1a" => :mojave
    sha256 "10dd5c2b9c6613b5310f95931d7233a8b7947c541433fcc5891ce837c45595a0" => :high_sierra
    sha256 "85c7bf74ba9b0209a08f2b87d69b54d03ec21985ad0bb7b9aeeda30c195529f8" => :sierra
  end

  keg_only :shadowed_by_macos,
    "macOS provides the BSD gettext library & some software gets confused if both are in the library path"

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
