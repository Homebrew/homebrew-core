class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  url "https://c-ares.haxx.se/download/c-ares-1.12.0.tar.gz"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+files/c-ares_1.12.0.orig.tar.gz"
  sha256 "8692f9403cdcdf936130e045c84021665118ee9bfea905d1a76f04d4e6f365fb"

  bottle do
    cellar :any
    sha256 "afee9065946f9b593df473247fbc0cea9e91da1c485a614ecfc2252f21fdad03" => :sierra
    sha256 "fecf1cd2f00321ded561d42f75ccdfaca4051daa23455a617dd347db8f4b493c" => :el_capitan
    sha256 "a31122fc87f53891cc925fe3371276a7f922234afabc0cc2ae861066b4f1a3a6" => :yosemite
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
