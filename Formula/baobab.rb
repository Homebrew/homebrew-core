class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.22/baobab-3.22.0.tar.xz"
  sha256 "796e784886d5bdf2e9d8ac94d74d5f94e055f4285ef54dc16552fb9c9b9c3e99"

  bottle do
    sha256 "5acff5f090ec3f72ed8c69cb4af7b7a12bf65705cebbc991f7603792ce9a7b66" => :sierra
    sha256 "633c2b902158aaf5d0cac1b8a82ccaf6ecb70d01e47d9fee45d42f78d925a19b" => :el_capitan
    sha256 "f3a996bf3fe194d20d133b928ddfbfa52e063199280dee590b88afa09a3b7558" => :yosemite
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
