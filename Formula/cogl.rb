class Cogl < Formula
  desc "Low level OpenGL abstraction library developed for Clutter"
  homepage "https://developer.gnome.org/cogl/"
  url "https://download.gnome.org/sources/cogl/1.22/cogl-1.22.4.tar.xz"
  sha256 "5217bf94cbca3df63268a3b79d017725382b9e592b891d1e7dc6212590ce0de0"

  bottle do
    sha256 "e8101f1075c0f7754670e94355b6adee2981cbc06f2cd06221e06009a730213f" => :mojave
    sha256 "d5cf5821953809ef2d1cefbffec2f6e44a6eaa65ce377e867e938b03983f7125" => :high_sierra
    sha256 "29ba6e0eea677529b8558de0fc4a81b0ca3c26a6a8c517b92d3108785476d206" => :sierra
    sha256 "cb19f43f005213580caec8ef9bacb024df5839b0d5a2a337ec6c189340d78548" => :el_capitan
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
