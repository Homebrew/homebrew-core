class GtkEngines < Formula
  desc "Themes for GTK+"
  homepage "https://git.gnome.org/browse/gtk-engines/"
  url "https://download.gnome.org/sources/gtk-engines/2.20/gtk-engines-2.20.2.tar.bz2"
  sha256 "15b680abca6c773ecb85253521fa100dd3b8549befeecc7595b10209d62d66b5"
  revision 1

  bottle do
    cellar :any
    sha256 "1518ae315fe5a20a141428080824583f18ae8dd9736d3f7b6e93937f3d3bd639" => :sierra
    sha256 "e6675468c5c8e18405ad1d6a7b8dec13da67048425f335ca92c7b26897a8fc97" => :el_capitan
    sha256 "8beee72b3290b89cc96a3a6889581eb87919309f5c75c9bc1447beeff1557791" => :yosemite
    sha256 "3519e1bec0070f54f5def933917e8f6dff085017c7ef4ebf3a8352c6454e919c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "cairo"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert (share/"gtk-engines/clearlooks.xml").exist?
    assert (lib/"gtk-2.0/2.10.0/engines/libhcengine.so").exist?
    assert (share/"themes/Industrial/gtk-2.0/gtkrc").exist?
  end

  def caveats; <<-EOS.undent
    You will need to set:
      GTK_PATH=#{HOMEBREW_PREFIX}/lib/gtk-2.0
    as by default GTK looks for modules in Cellar.
    EOS
  end
end
