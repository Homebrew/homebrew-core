class Libxcb < Formula
  desc "X.Org: Interface to the X Window System protocol"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/libxcb-1.14.tar.gz"
  sha256 "2c7fcddd1da34d9b238c9caeda20d3bd7486456fc50b3cc6567185dbd5b0ad02"
  license "MIT"

  bottle do
    cellar :any
    sha256 "8d62bcf36239e430333af2204b1546606444c77c09b48c8c08e06b0528426545" => :catalina
    sha256 "86e8405269ea3972dfc2fb9fde8c1da709c4be85346906eaf018b0603257d509" => :mojave
    sha256 "e4c9db5bee37ecf410e8ee49aff2eafd1ec3b10c52a44e7af444788068110839" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "xcb-proto" => :build
  depends_on "libpthread-stubs"
  depends_on "libxau"
  depends_on "libxdmcp"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-dri3
      --enable-ge
      --enable-xevie
      --enable-xprint
      --enable-selinux
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-devel-docs=no
      --with-doxygen=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include "xcb/xcb.h"

      int main() {
        xcb_connection_t *connection;
        xcb_atom_t *atoms;
        xcb_intern_atom_cookie_t *cookies;
        int count, i;
        char **names;
        char buf[100];

        count = 200;

        connection = xcb_connect(NULL, NULL);
        atoms = (xcb_atom_t *) malloc(count * sizeof(atoms));
        names = (char **) malloc(count * sizeof(char *));

        for (i = 0; i < count; ++i) {
          sprintf(buf, "NAME%d", i);
          names[i] = strdup(buf);
          memset(buf, 0, sizeof(buf));
        }

        cookies = (xcb_intern_atom_cookie_t *) malloc(count * sizeof(xcb_intern_atom_cookie_t));

        for(i = 0; i < count; ++i) {
          cookies[i] = xcb_intern_atom(connection, 0, strlen(names[i]), names[i]);
        }

        for(i = 0; i < count; ++i) {
          xcb_intern_atom_reply_t *r;
          r = xcb_intern_atom_reply(connection, cookies[i], 0);
          if(r)
            atoms[i] = r->atom;
          free(r);
        }

        free(atoms);
        free(cookies);
        xcb_disconnect(connection);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lxcb"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
