class Libev < Formula
  desc "Asynchronous event library"
  homepage "https://software.schmorp.de/pkg/libev.html"
  url "https://dist.schmorp.de/libev/Attic/libev-4.33.tar.gz"
  mirror "https://fossies.org/linux/misc/libev-4.33.tar.gz"
  sha256 "507eb7b8d1015fbec5b935f34ebed15bf346bed04a11ab82b8eee848c4205aea"
  license any_of: ["BSD-2-Clause", "GPL-2.0-or-later"]

  livecheck do
    url "https://dist.schmorp.de/libev/"
    regex(/href=.*?libev[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6f3bcc66907452a0f795ad6532d69deacdb1059379ca5a94da3a3e286342f94c"
    sha256 cellar: :any,                 arm64_sequoia:  "67740e5ba01e82c140ceadc512aa26a3990bfadaef0f4b545ba7f9aaf24c50bf"
    sha256 cellar: :any,                 arm64_sonoma:   "e476d7fb265b97275a91a5cb3acfa0357e4f722d44a550ab3bc22388add80614"
    sha256 cellar: :any,                 arm64_ventura:  "45855fb985e74c97e1764ae481f1699e846441089cc3da65bdca5d8fc1b41243"
    sha256 cellar: :any,                 arm64_monterey: "2ae425f0f4435a6a01577bdf04723791f2c7bb67d6eeaacafca7aaca9450c55b"
    sha256 cellar: :any,                 arm64_big_sur:  "8ed86bdd0ff3b47f8802b251a9ca61770ffc4c9b0be964f41f50955256b5bb53"
    sha256 cellar: :any,                 sonoma:         "5de04c4e03a70639639d5e4ced919aafdef07f9ea98cbde320b2e9dd81f9d5ce"
    sha256 cellar: :any,                 ventura:        "6d0945ebe1bd085e597fedeee3fbcfba8f0d40195b03e4523894917b5b5526ca"
    sha256 cellar: :any,                 monterey:       "de9342ba34cfa8c2f8863a92eb7aced34652c302328f8a593a449d183c9fe1e0"
    sha256 cellar: :any,                 big_sur:        "95ddf4b85924a6a10d4a88b6eb52616fa8375e745c99d0752618d5bb82f5248a"
    sha256 cellar: :any,                 catalina:       "e5481e2ba48282bffb5ecc059f0ddddd9807400593e849ed4b48b1fed3a14698"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4fb42593fde919e166fd48c27050b5be92f2d2fe7b2e97e19738f8bd9428734d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a22fcf5d3733f1cd5814c5ae2c5a46c7c408195d408d3666b42696a0127f8bb5"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    # Remove compatibility header to prevent conflict with libevent
    (include/"event.h").unlink
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lev", "-o", "test"
    input = "hello, world\n"
    assert_equal input, pipe_output("./test", input, 0)
  end
end
