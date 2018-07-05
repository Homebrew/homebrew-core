class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.62/libsoup-2.62.2.tar.xz"
  sha256 "9e536fe3da60b25d2c63addb84a9d5072d00b0d8b8cbeabc629a6bcd63f879b6"

  bottle do
    sha256 "1272bebf7bb3ab258b2e01bceb82dce9a08cd8fb9ec604240a61c77afabbcbf3" => :high_sierra
    sha256 "9151f558ef5c9f291bc5044614aaf6fde277a1d08c1a796c188a718fc52127d7" => :sierra
    sha256 "224752dc0d4e4d71994c38da324c4625dc9c25f14a0607cdc6b32115feb4b01a" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "python" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "vala"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-tls-check
      --enable-introspection=yes
    ]

    # ensures that the vala files remain within the keg
    inreplace "libsoup/Makefile.in",
              "VAPIDIR = @VAPIDIR@",
              "VAPIDIR = @datadir@/vala/vapi"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsoup/soup.h>

      int main(int argc, char *argv[]) {
        guint version = soup_get_major_version();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libsoup-2.4
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lsoup-2.4
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
