class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  url "https://c-ares.haxx.se/download/c-ares-1.14.0.tar.gz"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+files/c-ares_1.14.0.orig.tar.gz"
  sha256 "45d3c1fd29263ceec2afc8ff9cd06d5f8f889636eb4e80ce3cc7f0eaf7aadc6e"

  bottle do
    cellar :any
    sha256 "f6778d973ae8c04a1e8abca2d77340b50e19a0448e90f5cdc110b515e62b05e9" => :high_sierra
    sha256 "e543ffa2ee246cd28e1dc0bb2ba1e2952266500419be8ed3a54d910c274f24be" => :sierra
    sha256 "5efb5340249ab0b5cd160632391e6e632fbaf8857742d66dbba9938df8ac9215" => :el_capitan
    sha256 "28977de886a3ca0cf08fae79d2b1abfb2d1c198b7a28c345dd37566ccbf8d670" => :yosemite
  end

  head do
    url "https://github.com/bagder/c-ares.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./buildconf" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-debug"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"
  end
end
