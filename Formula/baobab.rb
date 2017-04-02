class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.24/baobab-3.24.0.tar.xz"
  sha256 "5980e96df9f3d1751a969869ec07bc184ae3ad667d5a3eb06cf1297091fdfc3f"

  bottle do
    sha256 "aa7eceabd331973f0c55c6ab39f4040b4d9edf9505e2d9d203b79882ff7c8ab9" => :sierra
    sha256 "d33df22fb9fe15dad8dd8c88d5fd2be9e1e7be66260a2cba33cc54f26f7b80be" => :el_capitan
    sha256 "27caf811afcd62cccca6943be092e2f0b88e1fa3a7187917f446a9fdae9d6342" => :yosemite
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
