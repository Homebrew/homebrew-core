class Libev < Formula
  desc "Asynchronous event library"
  homepage "http://software.schmorp.de/pkg/libev.html"
  url "http://dist.schmorp.de/libev/Attic/libev-4.24.tar.gz"
  mirror "https://fossies.org/linux/misc/libev-4.24.tar.gz"
  sha256 "973593d3479abdf657674a55afe5f78624b0e440614e2b8cb3a07f16d4d7f821"

  bottle do
    cellar :any
    sha256 "ed173bfc28e6632e73b3a9aabcc999fff5cc8aab178ae94ae2a5df16f3660cf0" => :mojave
    sha256 "d6ff53dbbeb1f78dc213e04b76c7ec033b32022017eb4eb213b68f9bb91d0da1" => :high_sierra
    sha256 "f9eace710427fcb1d9c3e821da0ecab3d5ff60e3a00750a7bfd4b17fd3d3d872" => :sierra
    sha256 "3ff3f21def203c8a3d6175b659aa20cb6ed4bcdb8f6922087b4ec9c568e67c75" => :el_capitan
    sha256 "6a41433542500be7a4fc7c350494839add102a73e2c66ef7578c91c73036985b" => :yosemite
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
