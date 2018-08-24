class Libevent < Formula
  desc "Asynchronous event library"
  homepage "https://libevent.org/"
  url "https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz"
  sha256 "316ddb401745ac5d222d7c529ef1eada12f58f6376a66c1118eee803cb70f83d"

  bottle do
    cellar :any
    sha256 "9ab81f4ca9902042f7ea95d02bf36394c5cdc11d715b7f928badc9cf5724ca8b" => :mojave
    sha256 "61a8cf2df6d58f79678fad0f798b6a9d368245097f908e2f911f25cb3f7916cf" => :high_sierra
    sha256 "cdd11d67b5f49b94cf3fbfd24753f84082957e3d55680e2b5979eec19091e694" => :sierra
    sha256 "136a93a91c3724d0403b0d43d0b9a4bf6b857278c4ebb7c7585ef70a19b0964c" => :el_capitan
    sha256 "ef703db1b4cbdab35b89aabe80c225dd9b7a2c3ea14b1eae681478c5b9df15fe" => :yosemite
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
    (testpath/"test.c").write <<~EOS
      #include <event2/event.h>

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
