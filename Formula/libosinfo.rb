class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.5.0.tar.gz"
  sha256 "bf692567983478c92bde78d454c18d6196abb032b5a77f430b09a7ef92ec6089"

  bottle do
    sha256 "1e389f8641db3e8337190292693fcb2acf6f3c486a9a26ed94ceb4f1ab0fed92" => :mojave
    sha256 "767409ed525bd928fa89442845ba3e20fcaff718fef2bc6f892c47b07b6b6996" => :high_sierra
    sha256 "1a030c4d1e8aa908c957a0f70083b32df30cfe826ca2511ea672fea51d670659" => :sierra
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
