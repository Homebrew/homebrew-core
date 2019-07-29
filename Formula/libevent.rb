class Libevent < Formula
  desc "Asynchronous event library"
  homepage "https://libevent.org/"
  url "https://github.com/libevent/libevent/archive/release-2.1.10-stable.tar.gz"
  sha256 "52c9db0bc5b148f146192aa517db0762b2a5b3060ccc63b2c470982ec72b9a79"

  bottle do
    cellar :any
    sha256 "3f43999f92de5174fa646e00cb0998801af4865b0274ebf6c4de5d6df372c4be" => :mojave
    sha256 "50ee308d22d52de4f3b0ac5e5288f5a083cbca31cd59186cb05d9e293edada71" => :high_sierra
    sha256 "a3cf44a7ec1d8ea39853079a9a28a0acc4082c7beea02200dcba7e124ec6c9a4" => :sierra
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
    doc.install Dir["doxygen/html/*"]
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
