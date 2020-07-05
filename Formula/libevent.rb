class Libevent < Formula
  desc "Asynchronous event library"
  homepage "https://libevent.org/"
  url "https://github.com/libevent/libevent/archive/release-2.1.12-stable.tar.gz"
  sha256 "7180a979aaa7000e1264da484f712d403fcf7679b1e9212c4e3d09f5c93efc24"

  bottle do
    cellar :any
    sha256 "9d262f9ffb2268340a89c713826d8ca068bcac06c30baf49e6184ab4660d977a" => :catalina
    sha256 "1e14fc34baae0b65cac6d7c75bc5ed0ccb1f6bbaa30c8f0f8477ab8ba85fb3c5" => :mojave
    sha256 "89df3b053409a11d520e9ca88aed17221416c60c5799ec51813f8c2c7e3536de" => :high_sierra
    sha256 "a9bddcb861a3464a0e9111926e4cb8d932ad860540f571edb74d448ef5a54811" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
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
