class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/33/ngspice-33.tar.gz"
  sha256 "b99db66cc1c57c44e9af1ef6ccb1dcbc8ae1df3e35acf570af578f606f8541f1"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 "34a0920853748c8f3d2a4f345224b9c7bdc03f82d27c66788898e5a80453d7bc" => :big_sur
    sha256 "25ea0f5f85b04aed60864c0cb76df8b0ebb18926ffa63631b645c29f004464c0" => :arm64_big_sur
    sha256 "0e5f16893b51a7c07f9f5aebd2d0e0f40404e380d1be9b81a179533baaaef218" => :catalina
    sha256 "f366e430c2ad73979c3d1869e6619db951e88aaf0a94fd3e9ea9a819c6fa4c58" => :mojave
    sha256 "15639064eb1fd7cdb856cfed521d266c42afe4ac752723aa87a8dcbaeeee9fa3" => :high_sierra
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
