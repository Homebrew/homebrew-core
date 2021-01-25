class Cogl < Formula
  desc "Low level OpenGL abstraction library developed for Clutter"
  homepage "https://developer.gnome.org/cogl/"
  url "https://download.gnome.org/sources/cogl/1.22/cogl-1.22.8.tar.xz"
  sha256 "a805b2b019184710ff53d0496f9f0ce6dcca420c141a0f4f6fcc02131581d759"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "ec1ef03d2e1e855ae5277a2f599fb7ed83c221f0ae29d8c8a5f45277be96d869" => :big_sur
    sha256 "9a487a4bf7fbe5fdec29d902ba668fe20cbbc05e66864cb8d9c5fe564373e586" => :arm64_big_sur
    sha256 "37fdd46a2845adf0e8f4ce85d5a80384ea235e435ef5f42167622f5224e4e51f" => :catalina
    sha256 "eb37baaa178631afac43c8bb1c93cdf9b78dd7d44862c63dec598d54a51b201e" => :mojave
    sha256 "46de52386a1123e828d94598279a99a88e3819d8f1dac1a51f39850a321ff7f2" => :high_sierra
  end

  head do
    url "https://gitlab.gnome.org/GNOME/cogl.git"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
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

    system "./configure", *args
    system "make", "install"
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
