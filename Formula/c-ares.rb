class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "http://c-ares.haxx.se/"
  url "http://c-ares.haxx.se/download/c-ares-1.11.0.tar.gz"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+files/c-ares_1.11.0.orig.tar.gz"
  sha256 "b3612e6617d9682928a1d50c1040de4db6519f977f0b25d40cf1b632900b3efd"

  bottle do
    cellar :any
    sha256 "0f9c9324a68f35e41fb6acabf0df83fab845d4622825fde85fa96975c2c2cd2e" => :el_capitan
    sha256 "af089ddc82ae2a69301e9a0dd56d42124503f5326dc8ea69eff3a0e6e6cc360c" => :yosemite
    sha256 "174c21f00441ee9e3127138a62c8b0efd0333e8b0cf45dae92e87d294c742535" => :mavericks
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
    (testpath/"test.c").write <<-EOS.undent
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
