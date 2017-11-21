class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://spruce.sourceforge.io/gmime/"
  url "https://download.gnome.org/sources/gmime/3.0/gmime-3.0.4.tar.xz"
  sha256 "b67f9b76925644afed4ad2347402b748fc279fcfe87d73f3fd816b3f991942c8"

  bottle do
    sha256 "76ad40072ab4f83881dd1652b67e3476375ffd3b07af8e104ae025d738748247" => :high_sierra
    sha256 "b5641c07a141bb12e1630a6afbb1a62ba4e677fca6b45c96b3fdd5749b740606" => :sierra
    sha256 "f8a7c90d025eadda348088499dc0a6acbe51ac3eee6a394b54a0c72e430b2152" => :el_capitan
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
