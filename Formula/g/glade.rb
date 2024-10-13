class Glade < Formula
  desc "RAD tool for the GTK+ and GNOME environment"
  homepage "https://glade.gnome.org/"
  url "https://download.gnome.org/sources/glade/3.40/glade-3.40.0.tar.xz"
  sha256 "31c9adaea849972ab9517b564e19ac19977ca97758b109edc3167008f53e3d9c"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia:  "e162366f083df623dd7cd1854a781cdf3d520bfde698588abc9296ab33fd8804"
    sha256 arm64_sonoma:   "271ff90536f47461687153dc97dd25d5ba9ad4f22c1a087e303fc52f54646dda"
    sha256 arm64_ventura:  "a9a7c003418e9867e2ae9d1da7c4230a812638d06b1ff6626454c952e4107e16"
    sha256 arm64_monterey: "254b71a95a632595fc9314162cd89607fac7ee27890bf57155fc2882473258a2"
    sha256 sonoma:         "00e5ab66baac9cb320fc6f95281d3a0d647fef6c8f461c0ba4ff1c45ecc56a58"
    sha256 ventura:        "ce76321eef07573869f0f9d38048981c32780dc98e1e8cd40761dd62725c770d"
    sha256 monterey:       "6564eb300ee2bf7ad5b8d587cd77f66bddf91087626bb9b07c0148776a1fe95a"
    sha256 x86_64_linux:   "a68666c43b3c79b9532742a2351093d587fe0da66c369ba3e62ed35f223c4deb"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libxml2"
  depends_on "pango"

  uses_from_macos "libxslt" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gtk-mac-integration"
    depends_on "harfbuzz"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable icon-cache update
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dintrospection=true", "-Dgladeui=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # executable test (GUI)
    # fails in Linux CI with (glade:20337): Gtk-WARNING **: 21:45:31.876: cannot open display:
    system bin/"glade", "--version" if OS.mac?

    (testpath/"test.c").write <<~EOS
      #include <gladeui/glade.h>

      int main(int argc, char *argv[]) {
        gboolean glade_util_have_devhelp();
        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs gladeui-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
