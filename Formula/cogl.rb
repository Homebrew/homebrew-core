class Cogl < Formula
  desc "Low level OpenGL abstraction library developed for Clutter"
  homepage "https://developer.gnome.org/cogl/"
  url "https://download.gnome.org/sources/cogl/1.22/cogl-1.22.6.tar.xz"
  sha256 "6d134bd3e48c067507167c001200b275997fb9c68b08b48ff038211c8c251b75"

  bottle do
    sha256 "380a30aa14058b080ecde8b31c6ed9d2f6635655898d4d084cae08858a3e9c44" => :catalina
    sha256 "2554edab8c0f870b34541e0fc2340e60b2a00b51c645669d1bb7dfb872137fc5" => :mojave
    sha256 "fe8dcd5fc1ee71065255fe642e929db8248ca9c937dd04b3a2729c71d48a6650" => :high_sierra
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
