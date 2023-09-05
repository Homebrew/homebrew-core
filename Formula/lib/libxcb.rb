class Libxcb < Formula
  desc "X.Org: Interface to the X Window System protocol"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libxcb-1.16.tar.xz"
  sha256 "4348566aa0fbf196db5e0a576321c65966189210cb51328ea2bb2be39c711d71"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9d83f7db1397e0afdd378af99d7da6bce33932df317d069452d9290ee621c895"
    sha256 cellar: :any,                 arm64_monterey: "218d18008b39f761e9a77f8ff3f12162a6c8a86967cd55a71484fbc150c4053a"
    sha256 cellar: :any,                 arm64_big_sur:  "8640d6a1d1631651f91df5c2ddf3e683e8d95eec58f5da34838076fa5aa93ca2"
    sha256 cellar: :any,                 ventura:        "a647b59bc0edc97b407fb24ae0b407c15192253ff974a1215edbe472c2bb638c"
    sha256 cellar: :any,                 monterey:       "a8a235d90ceb77fe7cde801a86cab42c4b2566da1dc3ec9976ca65d45a4eaeb3"
    sha256 cellar: :any,                 big_sur:        "f0f3b01121bf2779d73b04d2b9c1f2bb851083f1d2ae191d5670cdd72335ccf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b9097b6fb09f58424307e917bd212568c009f9ff0ac8264433f94f6bc2392b5"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build # match version in `xcb-proto`
  depends_on "xcb-proto" => :build
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
