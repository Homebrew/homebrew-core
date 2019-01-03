class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "http://www.geeqie.org/"
  # URL needs to be an unshallow clone because it needs history to generate
  # the changelog documentation.
  # Unfortunately this means that the tarball can't be used to build;
  # this is documented in the makefile.
  url "https://github.com/BestImageViewer/geeqie.git",
      :tag      => "v1.4",
      :revision => "7c9b41e7c9be8cfc9b4f0a2459c0a1e0e4aaea5b",
      :shallow  => false
  revision 2

  bottle do
    sha256 "a559b5497adfaadb9ae785d47abf74f856ee0aa34126325a380565a0ec6836ad" => :mojave
    sha256 "0bf35c40d3d0fc9a3bb6d69cd079e7e3f9aae4d1c050cead01aca59bea009d22" => :high_sierra
    sha256 "54a1af6f886c7a95b3f66ea0996a6acfa1531b940d274921a84cdef57c1fc54f" => :sierra
    sha256 "2f84465d9d6eba2db0031c71033b735d33a6d6294dd2a15fd13d65674b60783b" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "exiv2"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "pango"

  # Fixes the build on OS X by assigning a value to a variable
  # before passing to WEXITVALUE.
  # https://github.com/BestImageViewer/geeqie/pull/589
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/9cacfd49be1db430d7a956132d6521e23fc85f77/geeqie/wexitstatus_fix.diff"
    sha256 "00bad28d46aafaaed99965a5c054bf04679c100c6f4f13ee82cf83c2782de349"
  end

  # Fix build with exiv 0.27
  # https://github.com/BestImageViewer/geeqie/pull/655
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9226ec07329457300c7af68986661f26f965436b/geeqie/exiv2_fix.diff?full_index=1"
    sha256 "2627bbb3a338456a8d80eedb260931991e427b4a9c8dee093400632970dd68db"
  end

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
