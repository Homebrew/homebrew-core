class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.19.8.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.19.8.1.tar.xz"
  sha256 "105556dbc5c3fbbc2aa0edb46d22d055748b6f5c7cd7a8d99f8e7eb84e938be4"

  bottle do
    sha256 "afc6a6120632b98d58b11fab82ae5e081206b89684dd948abf2d29caeb813ffd" => :mojave
    sha256 "99d2dbd4c9ebfe9bf2a64bd99f3a695a18635f0d9110eaff34bab8022abef6a8" => :high_sierra
    sha256 "8368522242c5fe33acd5c80b5f1321559da9efe20878da6e4b9507683a740c21" => :sierra
    sha256 "311475f36f3fd314ae0db4fb52e4ab769f62ded6c8c81678ad8295f41762e4ba" => :el_capitan
    sha256 "ca8fe572e7c8db00bb1bdfd66c379ba4a960927f4b829f47f9e2335c51dc7376" => :yosemite
    sha256 "e3091192716347fc54f6e8a8184d892feed5309672daa061a1407b071af80c05" => :mavericks
  end

  keg_only :shadowed_by_macos,
    "macOS provides the BSD gettext library & some software gets confused if both are in the library path"

  # https://savannah.gnu.org/bugs/index.php?46844
  depends_on "libxml2" if MacOS.version <= :mountain_lion

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-included-gettext",
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
