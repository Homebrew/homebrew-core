class Libev < Formula
  desc "Asynchronous event library"
  homepage "http://software.schmorp.de/pkg/libev.html"
  url "http://dist.schmorp.de/libev/Attic/libev-4.27.tar.gz"
  mirror "https://fossies.org/linux/misc/libev-4.27.tar.gz"
  sha256 "2d5526fc8da4f072dd5c73e18fbb1666f5ef8ed78b73bba12e195cfdd810344e"

  bottle do
    cellar :any
    sha256 "7cb7ab93ae3ff831d87fc7609ac8739c2ee72116c940663871d351f1d9a69a32" => :mojave
    sha256 "aa62e803e22fba70317f6ca2824b124b2f3c7e2196f20c4a33f7e760d22e6e42" => :high_sierra
    sha256 "48f828184c10df1a6e789987792006fbfc513942406e09d1d1b1cfa2dcd04399" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    # Remove compatibility header to prevent conflict with libevent
    (include/"event.h").unlink
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      /* Wait for stdin to become readable, then read and echo the first line. */

      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <ev.h>

      ev_io stdin_watcher;

      static void stdin_cb (EV_P_ ev_io *watcher, int revents) {
        char *buf;
        size_t nbytes = 255;
        buf = (char *)malloc(nbytes + 1);
        getline(&buf, &nbytes, stdin);
        printf("%s", buf);
        ev_io_stop(EV_A_ watcher);
        ev_break(EV_A_ EVBREAK_ALL);
      }

      int main() {
        ev_io_init(&stdin_watcher, stdin_cb, STDIN_FILENO, EV_READ);
        ev_io_start(EV_DEFAULT, &stdin_watcher);
        ev_run(EV_DEFAULT, 0);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lev", "-o", "test", "test.c"
    input = "hello, world\n"
    assert_equal input, pipe_output("./test", input, 0)
  end
end
