class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.28/gsettings-desktop-schemas-3.28.1.tar.xz"
  sha256 "f88ea6849ffe897c51cfeca5e45c3890010c82c58be2aee18b01349648e5502f"

  bottle do
    cellar :any_skip_relocation
    sha256 "84d8b9449e20e599ee00ce1d661c1bd0e4941344fe3631439c8d52133471bae8" => :mojave
    sha256 "39ef6c65974fe55184a8997c8b3a8de5f0dcc5b71f0bc457887381c2f567c154" => :high_sierra
    sha256 "39ef6c65974fe55184a8997c8b3a8de5f0dcc5b71f0bc457887381c2f567c154" => :sierra
    sha256 "39ef6c65974fe55184a8997c8b3a8de5f0dcc5b71f0bc457887381c2f567c154" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libffi"

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
