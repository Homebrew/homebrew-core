class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/3.18/ghex-3.18.2.tar.xz"
  sha256 "ebd341c49e2cc4e710230703cd20e9febb29b64e34a1b5396d6aa818936e55bf"

  bottle do
    sha256 "e62ccbe068c951cf4b0aba43302a012e2187bb3740546b9b0e306cf0b08e68f9" => :sierra
    sha256 "1bddbbe5d0ec759f23cffd8e9125492326417212762a45049c5375d2254385ff" => :el_capitan
    sha256 "c817ef9963054421bec94208ce55ac74209c27c0dbff8ce80be220afaa7b954b" => :yosemite
    sha256 "061169057a411c6b4f656b53124c7f92c5cf9898417ce1f39ec59fce7484c05c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => [:build, "with-python"]
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-schemas-compile",
                          "--prefix=#{prefix}"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/ghex", "--help"
  end
end
