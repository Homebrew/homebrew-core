class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  url "https://c-ares.haxx.se/download/c-ares-1.14.0.tar.gz"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+files/c-ares_1.14.0.orig.tar.gz"
  sha256 "45d3c1fd29263ceec2afc8ff9cd06d5f8f889636eb4e80ce3cc7f0eaf7aadc6e"

  bottle do
    cellar :any
    sha256 "90ff616a7b816ce090d1319e541ad45d7b515c2787007d10b7eace9601fb2396" => :high_sierra
    sha256 "82c529566254c10dd71d09ae23281cf4a2c75d16200cc4df6d406ddecde5ba16" => :sierra
    sha256 "3c9943c455dbb8a0f641f78fd93dec6a27937494021b8f94f1bfe381ded46ca3" => :el_capitan
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
