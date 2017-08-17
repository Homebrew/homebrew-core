class LibeventAT14 < Formula
  desc "Asynchronous event library"
  homepage "http://libevent.org"
  url "https://github.com/libevent/libevent/archive/release-1.4.15-stable.tar.gz"
  sha256 "e9a32238a98954081d7ed9918d8f799eb4c743fd570749c0721585140dd5de21"

  patch do
    url "https://github.com/carenas/libevent/commit/12752d4a3c87266616832bf4879738b2532aeade.patch"
    sha256 "486abf26cb7ba13733a67ba559e80f1bdf1938b544915845fa39e1009dff5538"
  end

  bottle do
    cellar :any
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "doxygen" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--disable-samples",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    rm_f "#{bin}/event_rpcgen.py"
    system "make", "doxygen"
    man3.install Dir["doxygen/man/man3/*.3"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <event.h>

      int main()
      {
        struct event_base *base;
        base = event_base_new();
        event_base_free(base);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-levent", "-o", "test"
    system "./test"
  end
end
