class Libdill < Formula
  desc "Structured concurrency in C"
  homepage "http://libdill.org/"
  url "https://github.com/sustrik/libdill/archive/2.14.tar.gz"
  sha256 "ebba0e5b433ec123b74a57d49b89dfa673aa258e03e6a452959e556b4c4529b9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 monterey:     "f3d32c4b24787b52512ae841b0daf82e256bb7f7e42dad115bbc059541103507"
    sha256 cellar: :any,                 big_sur:      "d0bc288a3ce54ab333f48ae08d127aa78300f6ee4921f0a9b59ca7f685649a93"
    sha256 cellar: :any,                 catalina:     "124f2fd7aa4ba68e528bd2700637511943ae55ec9c2b2c9dcdb3bff1f2e34909"
    sha256 cellar: :any,                 mojave:       "7ebbbe85ab5989b48664688c9fdc833b4bbc7846ea94f3f73c34ef620026b878"
    sha256 cellar: :any,                 high_sierra:  "062d2f9f6fdeb5588036d3e06752ecfd95b5f4e7b6008b727208fc0a2e7f50a6"
    sha256 cellar: :any,                 sierra:       "6f75a82c15eafe6818b0d79e9c55df0654c6665f37841ee21cf7fb90ac578a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6a7a4c9cd3cfe580d823fe85732058bbce181f915f348e1d9629bd93e86880f7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libdill.h>
      #include <stdio.h>
      #include <stdlib.h>

      coroutine void worker(const char *text) {
          while(1) {
              printf("%s\\n", text);
              msleep(now() + random() % 500);
          }
      }

      int main() {
          go(worker("Hello!"));
          go(worker("World!"));
          msleep(now() + 5000);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldill", "-o", "test"
    system "./test"
  end
end
