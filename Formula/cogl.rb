class Cogl < Formula
  desc "Low level OpenGL abstraction library developed for Clutter"
  homepage "https://developer.gnome.org/cogl/"
  url "https://download.gnome.org/sources/cogl/1.22/cogl-1.22.4.tar.xz"
  sha256 "5217bf94cbca3df63268a3b79d017725382b9e592b891d1e7dc6212590ce0de0"
  revision 1

  bottle do
    sha256 "031ac6cc09ab6332f5c922f0a70a4a13b6d0a01eb63502cf71702d0200b044b3" => :catalina
    sha256 "6b9f7bfe05979904a7bfd619e16502131eb216bb8d75f442ef2b9abaea252a7c" => :mojave
    sha256 "a503e6cdc62cfab89857540532f7de0414efdb7a39f12678f2be62d8673eb002" => :high_sierra
    sha256 "eb7471e236274b08f774e20b11755c84757ab7815ee44a99335d8465194fbbd1" => :sierra
  end

  head do
    url "https://gitlab.gnome.org/GNOME/cogl.git"
  end

  # The tarball contains a malfunctioning GNU Autotools setup
  # Running autoreconf is necessary to fix the build
  # Reported upstream at https://gitlab.gnome.org/GNOME/cogl/issues/8
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk-doc"
  depends_on "pango"

  def install
    # Don't dump files in $HOME.
    ENV["GI_SCANNER_DISABLE_CACHE"] = "yes"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-cogl-pango=yes
      --enable-introspection=yes
      --disable-glx
      --without-x
    ]

    system "autoreconf", "-fi"
    system "./configure", *args
    system "make", "install"
    doc.install "examples"
  end
  test do
    (testpath/"test.c").write <<~EOS
      #include <cogl/cogl.h>

      int main()
      {
          CoglColor *color = cogl_color_new();
          cogl_color_free(color);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/cogl",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           testpath/"test.c", "-o", testpath/"test",
           "-L#{lib}", "-lcogl"
    system "./test"
  end
end
