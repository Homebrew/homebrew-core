class Libxcb < Formula
  desc "X.Org: Interface to the X Window System protocol"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libxcb-1.17.0.tar.xz"
  sha256 "599ebf9996710fea71622e6e184f3a8ad5b43d0e5fa8c4e407123c88a59a6d55"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "73d103661722410b7789107ff2dc6d4290e6d6b3a48fe1311665bb4593110dc1"
    sha256 cellar: :any,                 arm64_ventura:  "28d4e84c5f80959fcccf10e66bded2fe5d506d66fb89682d40acb6e0cc0a4611"
    sha256 cellar: :any,                 arm64_monterey: "9c9f126aca70259930ccc652c9e208f2fa8db321ddadb31bc36af9c4ded4ac3a"
    sha256 cellar: :any,                 sonoma:         "13fa9f9277a82b642375ad327d412afe69b7ad593ef3c0745454f731dd333f27"
    sha256 cellar: :any,                 ventura:        "9184f59a65ee1c60eb22b5566a5b842f4730408f512c154ddf64ecbfac911b98"
    sha256 cellar: :any,                 monterey:       "32b18a3b435be0f22af8cbf093fbd6f299a7265982e7cde07c3b6e4642817604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c89a99c1bd6af9c2ee85f4c7bacd07906bb16e6ab515cd5d347f9f392dbd80a1"
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
