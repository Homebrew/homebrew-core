class Libevent < Formula
  desc "Asynchronous event library"
  homepage "http://libevent.org"
  url "https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz"
  sha256 "316ddb401745ac5d222d7c529ef1eada12f58f6376a66c1118eee803cb70f83d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "de2aeabfb41fb7e601fb33948b81da4cd56b88bd5d1bfe325370924e75a81fae" => :sierra
    sha256 "1f18bad6b4b19c55ed11b63256241558923eea26814a7d551cf7384ffe0dd098" => :el_capitan
    sha256 "8f02227ee85ed96fd3499befc12cf00aad34dcdf436f0b58f29945432a69d4b4" => :yosemite
    sha256 "e32a8b4b74b3a41fb7ccf7933f0cc883c16d9fbd8ed55ff3d204556afa9d1a41" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  conflicts_with "pincaster",
    :because => "both install `event_rpcgen.py` binaries"

  def install
    inreplace "Doxyfile", /GENERATE_MAN\s*=\s*NO/, "GENERATE_MAN = YES"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "doxygen"
    man3.install Dir["doxygen/man/man3/*.3"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <event2/event.h>

      int main()
      {
        struct event_base *base;
        base = event_base_new();
        event_base_free(base);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-levent", "-o", "test"
    system "./test"
  end
end
