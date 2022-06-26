class Libxcb < Formula
  desc "X.Org: Interface to the X Window System protocol"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/libxcb-1.15.tar.gz"
  sha256 "1cb65df8543a69ec0555ac696123ee386321dfac1964a3da39976c9a05ad724d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b9ed936a5ee43ec58cfa7db03a75ff2b336836c219c024c58f68fa3eecd91976"
    sha256 cellar: :any,                 arm64_big_sur:  "dbb71439521a388431894b8ba9ea8b9ee628046ccc71cc94acdd3511eceb4df1"
    sha256 cellar: :any,                 monterey:       "21ed8d16c03b188edebd5e0b20b1fca8e36763e159d75a63d5214873e78b1807"
    sha256 cellar: :any,                 big_sur:        "adfd6a48ce689095e518b3e05a7d1d775808c84aad660d6763ba27c95d154052"
    sha256 cellar: :any,                 catalina:       "78f6cd5fce9028f7909f2089c8307fd2dacc44d5edc8fe22ab9833e468dee48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "993d37bb436fab0157ed5f3c031f9a18168053439e93edb4bdce9abe6e99373d"
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
      PYTHON=python3
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
