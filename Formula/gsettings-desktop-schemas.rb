class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.22/gsettings-desktop-schemas-3.22.0.tar.xz"
  sha256 "0f06c7ba34c3a99e4d58b10889496133c9aaad6698ea2d8405d481c7f1a7eae1"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff66a60ec389eb26aea4dc7487497b9c18977a4623aa83fa84ca74e418d9b04d" => :sierra
    sha256 "092011db325353661a9f4c2473341e0202b3d634e03fc978ef7a53a9b3799c09" => :el_capitan
    sha256 "7917278eb4a79cc63e11e68aee8fa67cb559a853efa63dd5ed69ae588436f6e4" => :yosemite
    sha256 "003a8e6824bddb40d5abfab5026d6ce030b93d8a4a75bd8b8e7d3f9577a14e3c" => :mavericks
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
