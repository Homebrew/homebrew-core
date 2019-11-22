class Libev < Formula
  desc "Asynchronous event library"
  homepage "http://software.schmorp.de/pkg/libev.html"
  url "http://dist.schmorp.de/libev/Attic/libev-4.27.tar.gz"
  mirror "https://fossies.org/linux/misc/libev-4.27.tar.gz"
  sha256 "2d5526fc8da4f072dd5c73e18fbb1666f5ef8ed78b73bba12e195cfdd810344e"

  bottle do
    cellar :any
    sha256 "4ceceecddfe182324e9aac9ee12ce26c98d7702b54fcc8be10d8525a2d1f7fd6" => :catalina
    sha256 "4cfba6111b46c11b0dc714e3e6905c54f9724d84f364acce1525b7465ca4a83b" => :mojave
    sha256 "c789236eff8445d3de322a7361677519ef52fc453dc135c0d3b2dea493d126f4" => :high_sierra
    sha256 "c3c3d536d0cc1a07b4bffed95b48c958e562f0430c05e2c362fa1b96c95234ae" => :sierra
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
