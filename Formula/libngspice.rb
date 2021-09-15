class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/35/ngspice-35.tar.gz"
  sha256 "c1b7f5c276db579acb3f0a7afb64afdeb4362289a6cab502d4ca302d6e5279ec"

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 arm64_big_sur: "01054bb2006ea4677a5e1b95910e57b8ced84f9e778a89b01da3edb34d05725c"
    sha256 big_sur:       "e131229e4c554e7831094bb19e1a4741385877eb0bf2cabfca9b6179476b9479"
    sha256 catalina:      "17794a5f1e6e1b9a4bd8c45b4a45ab5cbf7755885eee0508948e1991e24cd2ec"
    sha256 mojave:        "855fd851ca4492c2c8476763f8cc4ce6cc67681e37560d76786e685f61db18e2"
    sha256 x86_64_linux:  "28f28030b9a69ccb91734230d407e3cdb04cf757c179e5cafbab6c7cf65af402"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

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
