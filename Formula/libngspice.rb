class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/34/ngspice-34.tar.gz"
  sha256 "2263fffc6694754972af7072ef01cfe62ac790800dad651bc290bfcae79bd7b5"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "030028e4b85b595d98edaa642acbba72207f05d9ee7dc6f43ba2491398d128ab"
    sha256 big_sur:       "a317cf13dd747369eb178e18f932ee4b0e3eebf8ffdb697f19cdaa1d100e20e8"
    sha256 catalina:      "82d6d7ad4cf74d36b1f11741edc123b76bdd48279cb0af38d5eacfe155c8b7de"
    sha256 mojave:        "908c45d65d80ad97d76a721ece430e09f8b828197999ee71152b2c12c5a4b231"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-ngshared
      --enable-cider
      --enable-xspice
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cstdlib>
      #include <ngspice/sharedspice.h>
      int ng_exit(int status, bool immediate, bool quitexit, int ident, void *userdata) {
        return status;
      }
      int main() {
        return ngSpice_Init(NULL, NULL, ng_exit, NULL, NULL, NULL, NULL);
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lngspice", "-o", "test"
    system "./test"
  end
end
