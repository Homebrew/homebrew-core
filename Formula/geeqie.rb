class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "http://www.geeqie.org/"
  # URL needs to be an unshallow clone because it needs history to generate
  # the changelog documentation.
  # Unfortunately this means that the tarball can't be used to build;
  # this is documented in the makefile.
  url "https://github.com/BestImageViewer/geeqie.git",
    :tag => "v1.4",
    :shallow => false

  bottle do
    sha256 "e50d0eda8d81d376738422943730510707ddf4cba4ca6541e1ac3428479b981c" => :high_sierra
    sha256 "f0282fc79dfe15708c2ce91dc4cb1a756005a847277892afa056d23d6accb007" => :sierra
    sha256 "a09af4df9793bcd89d55445dea5e8de6d229cb81cc997cbc82edbe5c2e3e44d2" => :el_capitan
  end

  # Fixes the build on OS X by assigning a value to a variable
  # before passing to WEXITVALUE.
  # https://github.com/BestImageViewer/geeqie/pull/589
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/9cacfd49be1db430d7a956132d6521e23fc85f77/geeqie/wexitstatus_fix.diff"
    sha256 "00bad28d46aafaaed99965a5c054bf04679c100c6f4f13ee82cf83c2782de349"
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gdk-pixbuf"
  depends_on "pango"
  depends_on "cairo"
  depends_on "libtiff"
  depends_on "jpeg"
  depends_on "atk"
  depends_on "glib"
  depends_on "imagemagick"
  depends_on "exiv2"
  depends_on "little-cms2"
  depends_on "adwaita-icon-theme"

  def install
    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-gtktest",
                          "--enable-gtk3"
    system "make", "install"
  end

  test do
    system "#{bin}/geeqie", "--version"
  end
end
