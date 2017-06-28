class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://spruce.sourceforge.io/gmime/"
  url "https://download.gnome.org/sources/gmime/3.0/gmime-3.0.1.tar.xz"
  sha256 "c28459ea86107e3a04ad06081f0b2b96b57f0774db44bae7a72ae18ad6483e00"

  bottle do
    sha256 "8bce8a92be361ea532e19ac04699dff58e422d571e835ecbf1c3e9dfc54c3fd0" => :sierra
    sha256 "d43d3106c3d1bfeb5ab6a7a04cbd7fce51435fe48d5c575aab34fd3916db4492" => :el_capitan
    sha256 "0b5b13d467bbc99ab66611a2f08e02a819a276750a262532d9aa6699198d8cbb" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection" => :recommended
  depends_on "glib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-largefile
      --disable-vala
      --disable-glibtest
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
    (testpath/"test.c").write <<-EOS.undent
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
