class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v1.7.2/geeqie-1.7.2.tar.xz"
  sha256 "186c10fae05dd81783f5218432e777cae2e9579ce884e65afa0884c357192269"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "9fc6cb5e50ff817eee866d888233ef1ba570381dffde40232e965add2981bb8a"
    sha256 arm64_big_sur:  "72e256d7f4fe30fba145294fe3c12853259233e4bdf2582cc8f1e8a1032b952b"
    sha256 monterey:       "0e47fbb798d89b724a8fa5f40b6d195ed25ac69fe871b7e7e34376cde2c5304d"
    sha256 big_sur:        "2aa83988145308caaa7bdd49b0fabfff7e2b7805c988f4cb5a782696355d53e7"
    sha256 catalina:       "6cd0177bb8e510ce20c440f21491e390e0f4339cb0461bc24fa2e0cadda17a99"
    sha256 mojave:         "de5e6de4c8b6098193cff623e96f0fbbd9204705bff0accfc1c354cfd8cc95e5"
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
  depends_on "libx11"
  depends_on "little-cms2"
  depends_on "pango"

  def install
    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh" # Seems to struggle to find GTK headers without this
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
