class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.20/baobab-3.20.1.tar.xz"
  sha256 "e9dff12a76b0d730ce224215860512eb0188280c622faf186937563b96249d1f"

  bottle do
    sha256 "9fbcf149add8e5367b74ef5f1b4eb1dd1c4dd43daad3736a2540172720d2cfa3" => :sierra
    sha256 "2c8716685d745afb1ac24ba61d96d9a08a4e8dd2fe0b5412a6ccdb1f744cd7f5" => :el_capitan
    sha256 "c9194f003ce07fc6688622580f3f9efdbaba76da8c8af5ebdf633e9542996cf1" => :yosemite
    sha256 "9611904e45132e879e2828134ec704beccfb57ce6cf2c80d099acba96261022a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => ["with-python", :build]
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end
