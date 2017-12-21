class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://spruce.sourceforge.io/gmime/"
  url "https://download.gnome.org/sources/gmime/3.2/gmime-3.2.0.tar.xz"
  sha256 "75ec6033f9192488ff37745792c107b3d0ab0a36c2d3e4f732901a771755d7e0"

  bottle do
    sha256 "bec06338aab6e19d38a2586ee9551b382d5ff8d2c7923b9595ffa9cc3666fd16" => :high_sierra
    sha256 "ac12b9473ad575fa21595401b220232cdc9ea608be9201950ce45eb2d7a12c8a" => :sierra
    sha256 "d8005dabb23d580b39bb3bc15c88f410f6660ed57bc4654f5443946d1f78ce63" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection" => :recommended
  depends_on "glib"
  depends_on "gpgme"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-largefile
      --disable-vala
      --disable-glibtest
      --enable-crypto
    ]

    if build.with? "gobject-introspection"
      args << "--enable-introspection"
    else
      args << "--disable-introspection"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <gmime/gmime.h>
      int main (int argc, char **argv)
      {
        g_mime_init();
        if (gmime_major_version>=3) {
          return 0;
        } else {
          return 1;
        }
      }
      EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gmime-3.0
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgmime-3.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
