class Libxcb < Formula
  desc "X.Org: Interface to the X Window System protocol"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/libxcb-1.14.tar.gz"
  sha256 "2c7fcddd1da34d9b238c9caeda20d3bd7486456fc50b3cc6567185dbd5b0ad02"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6c7154002b268eb74f36215a5d0b6496dacb3ff786bb40c29a2151359c219476"
    sha256 cellar: :any,                 arm64_big_sur:  "e473ad5c0877fa07f64037bcf12df7396f5aed59a2ff89a1b5eaa1a6e2885fcd"
    sha256 cellar: :any,                 monterey:       "aa439c61a2c0174f7d9f505fed55798a2dd4309221f3c51535c4fba5caa5162e"
    sha256 cellar: :any,                 big_sur:        "c499695d4451922107256515154334e89fbafb3825b68f9c9f5d957f1398968e"
    sha256 cellar: :any,                 catalina:       "118d9fa08edc88e58530f3920ddccba38e3eae0d08b280ff61e5eed9b5a87e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105c626775006b99f03f67dd80a0ec5ef84e9163353cd33a8b39193fdf231936"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
