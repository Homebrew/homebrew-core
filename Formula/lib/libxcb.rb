class Libxcb < Formula
  desc "X.Org: Interface to the X Window System protocol"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libxcb-1.17.0.tar.xz"
  sha256 "599ebf9996710fea71622e6e184f3a8ad5b43d0e5fa8c4e407123c88a59a6d55"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "059edd054b17234abb0ce8a34dcbbd927e104445d09a3f5904ea82f7c5aa7ded"
    sha256 cellar: :any,                 arm64_sequoia: "cce8d9e12c3f0b2fdbffbb3f7ba02f7e25cf3fa495b3e759d34a6264599543b3"
    sha256 cellar: :any,                 arm64_sonoma:  "103f2b2f44b6dfd22bc936c9eb7f325b598374c549a9f56465b8cce80a2ea829"
    sha256 cellar: :any,                 arm64_ventura: "3de506a3b5fd61bdd3f1cd5a244b82ea34b696894c8c3124e844a37ff6afd8c7"
    sha256 cellar: :any,                 sonoma:        "d7cbef805f6d1aab547a65a931972df59a768bb48ff845ecdcbf7b404f64cfa6"
    sha256 cellar: :any,                 ventura:       "b0bd40b6aba450db00c38a98d4a1e3b8cf3335f4df18e4044e60e1b0ad7fb481"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ab6cbc2dd873785c24e669f1749dc1e694740b9de496eef4289be27f389c79d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ccb2f6e9f4feb73b3dbc56248554bc8ce30cb34771ed987eec1bd956f8563e2"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build # match version in `xcb-proto`
  depends_on "xcb-proto" => :build
  depends_on "libxau"
  depends_on "libxdmcp"

  def install
    python3 = "python3.14"

    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-dri3
      --enable-ge
      --enable-xevie
      --enable-xprint
      --enable-selinux
      --disable-silent-rules
      --enable-devel-docs=no
      --with-doxygen=no
      PYTHON=#{python3}
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lxcb"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
