class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.28/gsettings-desktop-schemas-3.28.0.tar.xz"
  sha256 "4cb4cd7790b77e5542ec75275237613ad22f3a1f2f41903a298cf6cc996a9167"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bd6835780ef3b7b9b2940c8c2e33b8257bc367883d897905e3c55ace5c35033" => :high_sierra
    sha256 "0bd6835780ef3b7b9b2940c8c2e33b8257bc367883d897905e3c55ace5c35033" => :sierra
    sha256 "0bd6835780ef3b7b9b2940c8c2e33b8257bc367883d897905e3c55ace5c35033" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gobject-introspection" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "libffi"
  depends_on "python@2" if MacOS.version <= :mavericks

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
