class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.22/gsettings-desktop-schemas-3.22.0.tar.xz"
  sha256 "0f06c7ba34c3a99e4d58b10889496133c9aaad6698ea2d8405d481c7f1a7eae1"

  bottle do
    cellar :any_skip_relocation
    sha256 "fde7cebb7ab94874c1d4af67d68e69f5927663c5d7f66751d5ec3a5624f263a4" => :sierra
    sha256 "fde7cebb7ab94874c1d4af67d68e69f5927663c5d7f66751d5ec3a5624f263a4" => :el_capitan
    sha256 "fde7cebb7ab94874c1d4af67d68e69f5927663c5d7f66751d5ec3a5624f263a4" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end
end
