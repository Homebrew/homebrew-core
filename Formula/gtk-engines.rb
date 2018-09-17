class GtkEngines < Formula
  desc "Themes for GTK+"
  homepage "https://github.com/GNOME/gtk-engines"
  url "https://download.gnome.org/sources/gtk-engines/2.20/gtk-engines-2.20.2.tar.bz2"
  sha256 "15b680abca6c773ecb85253521fa100dd3b8549befeecc7595b10209d62d66b5"
  revision 2

  bottle do
    cellar :any
    sha256 "81cf03638e971d511d0e86d65c1f01c8310aa7754e590711a27eed80d294db9a" => :mojave
    sha256 "e6128438b5f07db8e57605a7ed9c1b03179eecb8e749f11c4098299d2a70e3bc" => :high_sierra
    sha256 "b1bd8d6ea69096a0c424b839e79a1ccf9af63bb043e240172e26e591b4b31641" => :sierra
    sha256 "fb5dc9cc323a8c02b699bb31285fb33ae9d43ada7a2e3034dba67228f693ca17" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gettext"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    You will need to set:
      GTK_PATH=#{HOMEBREW_PREFIX}/lib/gtk-2.0
    as by default GTK looks for modules in Cellar.
  EOS
  end

  test do
    assert_predicate pkgshare/"clearlooks.xml", :exist?
    assert_predicate lib/"gtk-2.0/2.10.0/engines/libhcengine.so", :exist?
    assert_predicate share/"themes/Industrial/gtk-2.0/gtkrc", :exist?
  end
end
