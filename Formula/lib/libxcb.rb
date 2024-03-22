class Libxcb < Formula
  desc "X.Org: Interface to the X Window System protocol"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libxcb-1.16.1.tar.xz"
  sha256 "f24d187154c8e027b358fc7cb6588e35e33e6a92f11c668fe77396a7ae66e311"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "59c243033b0a5515e65c81967116fb5852e8644f14b94dec3463140ecc6a2502"
    sha256 cellar: :any,                 arm64_ventura:  "86dc3b8e7bcc94c1d18ba91cd98e3b496a430fbbfed3e08a10dd54d3d3bbc657"
    sha256 cellar: :any,                 arm64_monterey: "2293193971812b9e2bb5d2a1a6e83df798404bfcbf15525d8915b12c732d1e95"
    sha256 cellar: :any,                 sonoma:         "1667406532bebd840f67717678a9f7f0555b20d403192f91d97ab5c9be51c3ee"
    sha256 cellar: :any,                 ventura:        "0f89c136dd2b6a64cdb3be0864123298db5bea9f2af7a0fb4382d6a74848055d"
    sha256 cellar: :any,                 monterey:       "95b00cc34e3273fa8aa75a6e87c7414d048ecc95a6cf81e34d83c502142e9211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9106516964c0c3f37198fc21184fe5dfd9170a381f39141184546987d5e9c0a8"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build # match version in `xcb-proto`
  depends_on "xcb-proto" => :build
  depends_on "libxau"
  depends_on "libxdmcp"

  def install
    python3 = "python3.12"

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
