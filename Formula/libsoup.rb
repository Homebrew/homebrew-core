class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://live.gnome.org/LibSoup"
  url "https://download.gnome.org/sources/libsoup/2.62/libsoup-2.62.0.tar.xz"
  sha256 "ab7c7ae8d19d0a27ab3b6ae21599cec8c7f7b773b3f2b1090c5daf178373aaac"
  revision 1

  bottle do
    sha256 "5ec289e00108fcd004ddcb8b3003a75c97f812af9ff90498c08b29614a9e60c6" => :high_sierra
    sha256 "fd78aff99206186df8f4b573567f00fd0bbc0862e50489668b1d78274d011cff" => :sierra
    sha256 "0a5e00e6ea4f52981e9bd6503b939c554749a9713f02e8f00fdcfd2e0d79e65b" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "python" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "sqlite"
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
