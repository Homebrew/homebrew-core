class Libxcb < Formula
  desc "X.Org: Interface to the X Window System protocol"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/libxcb-1.15.tar.gz"
  sha256 "1cb65df8543a69ec0555ac696123ee386321dfac1964a3da39976c9a05ad724d"
  license "MIT"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "2a2826a150a07d7cb11afc60822d235156f4b0e26fce2b40127aa427c1d702d5"
    sha256 cellar: :any,                 arm64_monterey: "34c950a057d5ab61955426066cf0b4028aba0d5d8ddd7c556b7d989dce2b0ec2"
    sha256 cellar: :any,                 arm64_big_sur:  "ce95f3522bad8371d68f1e7aa27f0a88dc884b25eab0cc53f78eb8bcee0e6026"
    sha256 cellar: :any,                 ventura:        "393ade919790d2f0ce71b512dbc7fe2c130b96583be8134b4979ed2e429b36ec"
    sha256 cellar: :any,                 monterey:       "1f471c5dbe29f01607bf6ea8002ffd3aa4f8c4cba499b922a0f4934cbec1e8f5"
    sha256 cellar: :any,                 big_sur:        "7be267fa471ac12bcf57d239da4f50a274752b025387fb5e8e592537cf93dfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbcc3c77c22a8193a29762a400d259b6f7836b31a0b04c2e76ac7fe5e0c83466"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build # match version in `xcb-proto`
  depends_on "xcb-proto" => :build
  depends_on "libxau"
  depends_on "libxdmcp"

  # Drop libpthread-stubs on macOS
  # remove in next release
  patch :DATA

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

__END__
diff --git a/configure b/configure
index 2503d4b..0c36685 100755
--- a/configure
+++ b/configure
@@ -20662,7 +20662,7 @@ printf "%s\n" "yes" >&6; }
 fi
 NEEDED="xau >= 0.99.2"
 case $host_os in
-linux*) ;;
+linux*|darwin*) ;;
      *) NEEDED="$NEEDED pthread-stubs" ;;
 esac
 
