class Libxcb < Formula
  desc "X.Org: Interface to the X Window System protocol"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/libxcb-1.15.tar.gz"
  sha256 "1cb65df8543a69ec0555ac696123ee386321dfac1964a3da39976c9a05ad724d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "1c61b275a2a61d1f0d089e7c0836e3515f0d344726ff5098f7ae550577b47b4a"
    sha256 cellar: :any,                 arm64_monterey: "0cdfcc168853b8f09f431c1790ae9b8de5d8567b5fab5381f26af300bb7dc5b3"
    sha256 cellar: :any,                 arm64_big_sur:  "6bf77051114dec12e0c541bc478d7833a992792047553fc821f3e1a17b82ec38"
    sha256 cellar: :any,                 ventura:        "87313e4ffe14ad6a8495a2b909963625886a82869e4463c7dc26ee803ad8d23a"
    sha256 cellar: :any,                 monterey:       "3847eca62ce6198e7a728df8ae431f628091fb8e83956efdc9d527f4d2795ef3"
    sha256 cellar: :any,                 big_sur:        "c1436addb2cb20e446f6147c10752e517336245b6dcdd946273537e60aa040eb"
    sha256 cellar: :any,                 catalina:       "035b1d299e3f1b41581e759981cf9a83aee2754c4b744cdcad4c7fe32de83ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8e96bb6f8a1e84ddc0b7e32ca3bd3ae05e4006785ca58b8356db00bd81879fa"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build # match version in `xcb-proto`
  depends_on "xcb-proto" => :build
  depends_on "libpthread-stubs"
  depends_on "libxau"
  depends_on "libxdmcp"

  def install
    python3 = "python3.11"

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

    system "./configure", *std_configure_args, *args
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
