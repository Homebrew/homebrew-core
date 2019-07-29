class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.5.0.tar.gz"
  sha256 "bf692567983478c92bde78d454c18d6196abb032b5a77f430b09a7ef92ec6089"
  revision 1

  bottle do
    sha256 "1d028a79be8109c00e46e4339861c4fbb6e503ffce646a5057613c0b0777da58" => :mojave
    sha256 "b3d146798995b0a5878b26201e9dc2833759b229a55c8b34003dadd5791c9dd9" => :high_sierra
    sha256 "0fc8647922adcb43897a9d44f8c4ce606ce58eaba460139ea108c4eb63fb6a6c" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "libxml2"

  def install
    # avoid wget dependency
    inreplace "Makefile.in", "wget -q -O", "curl -o"

    # sh lives at /bin/sh on macOS, not /usr/bin/sh
    inreplace "build-aux/install-sh", "#!/usr/bin/sh", "#!/bin/sh"

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-vala
      --enable-introspection
      --enable-tests
    ]

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <osinfo/osinfo.h>

      int main(int argc, char *argv[]) {
        OsinfoPlatformList *list = osinfo_platformlist_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libosinfo-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -losinfo-1.0
      -lglib-2.0
      -lgobject-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
