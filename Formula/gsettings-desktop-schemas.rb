class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.24/gsettings-desktop-schemas-3.24.1.tar.xz"
  sha256 "76a3fa309f9de6074d66848987214f0b128124ba7184c958c15ac78a8ac7eea7"

  bottle do
    cellar :any_skip_relocation
    sha256 "6852bd372272eb28017382189011107af8563211a86ef4e8f9b686cef440fc66" => :high_sierra
    sha256 "e4f5ab8d16e84e09cf10439b7f827d80b403efe598e3b05d593b745d1d5675fa" => :sierra
    sha256 "e4f5ab8d16e84e09cf10439b7f827d80b403efe598e3b05d593b745d1d5675fa" => :el_capitan
    sha256 "e4f5ab8d16e84e09cf10439b7f827d80b403efe598e3b05d593b745d1d5675fa" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gobject-introspection" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "libffi"
  depends_on "python" if MacOS.version <= :mavericks

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile",
                          "--enable-introspection=yes"
    system "make", "install"
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end
end
