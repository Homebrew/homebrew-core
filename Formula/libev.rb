class Libev < Formula
  desc "Asynchronous event library"
  homepage "http://software.schmorp.de/pkg/libev.html"
  url "http://dist.schmorp.de/libev/Attic/libev-4.33.tar.gz"
  mirror "https://fossies.org/linux/misc/libev-4.33.tar.gz"
  sha256 "507eb7b8d1015fbec5b935f34ebed15bf346bed04a11ab82b8eee848c4205aea"

  livecheck do
    url "http://dist.schmorp.de/libev/"
    regex(/href=.*?libev[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2ae425f0f4435a6a01577bdf04723791f2c7bb67d6eeaacafca7aaca9450c55b"
    sha256 cellar: :any,                 arm64_big_sur:  "8ed86bdd0ff3b47f8802b251a9ca61770ffc4c9b0be964f41f50955256b5bb53"
    sha256 cellar: :any,                 monterey:       "de9342ba34cfa8c2f8863a92eb7aced34652c302328f8a593a449d183c9fe1e0"
    sha256 cellar: :any,                 big_sur:        "95ddf4b85924a6a10d4a88b6eb52616fa8375e745c99d0752618d5bb82f5248a"
    sha256 cellar: :any,                 catalina:       "e5481e2ba48282bffb5ecc059f0ddddd9807400593e849ed4b48b1fed3a14698"
    sha256 cellar: :any,                 mojave:         "f6cfb8c6bb1219f4a54d36113ada7cc7e1e446d5a207bc77d69ac30d9cfe391f"
    sha256 cellar: :any,                 high_sierra:    "f623fc2f4dc3a0980b4733945eb2025cd40636a6d4f5e5d75ae5f89e0b7b07bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a22fcf5d3733f1cd5814c5ae2c5a46c7c408195d408d3666b42696a0127f8bb5"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lev", "-o", "test"
    input = "hello, world\n"
    assert_equal input, pipe_output("./test", input, 0)
  end
end
