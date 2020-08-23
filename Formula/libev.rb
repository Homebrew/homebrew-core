class Libev < Formula
  desc "Asynchronous event library"
  homepage "http://software.schmorp.de/pkg/libev.html"
  url "http://dist.schmorp.de/libev/Attic/libev-4.33.tar.gz"
  mirror "https://fossies.org/linux/misc/libev-4.33.tar.gz"
  sha256 "507eb7b8d1015fbec5b935f34ebed15bf346bed04a11ab82b8eee848c4205aea"

  bottle do
    cellar :any
    sha256 "e5481e2ba48282bffb5ecc059f0ddddd9807400593e849ed4b48b1fed3a14698" => :catalina
    sha256 "f6cfb8c6bb1219f4a54d36113ada7cc7e1e446d5a207bc77d69ac30d9cfe391f" => :mojave
    sha256 "f623fc2f4dc3a0980b4733945eb2025cd40636a6d4f5e5d75ae5f89e0b7b07bd" => :high_sierra
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
