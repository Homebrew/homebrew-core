class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"

  stable do
    url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/37/ngspice-37.tar.gz"
    sha256 "9beea6741a36a36a70f3152a36c82b728ee124c59a495312796376b30c8becbe"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "570a9fc2cef0e38a6fc50413efff7cd1510fd5cfe45b418d9084f4500f00d443"
    sha256 cellar: :any,                 arm64_big_sur:  "d6cc2b395086bdabcd8c82a8d80b0447abf14c5f54c1292c422a182f136c6cd3"
    sha256 cellar: :any,                 monterey:       "f34f1c28d673e2a3f4a65eeaefe43d252823674cf5429f8db264a95f85b2b69c"
    sha256 cellar: :any,                 big_sur:        "470615d662b09d1301509575e1d76ee703a086d08344acb0b53e22008ea31877"
    sha256 cellar: :any,                 catalina:       "08e2cf42d85bc36c66b3c4fe5310354389ab72bc68fbe25c867e9e1136e5c8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9f0287c2f22f2e517257128cdf3b5e37d1e5e44cb76fdc5df348b98cce0b188"
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

    # remove script files
    rm_rf Dir[share/"ngspice/scripts"]
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
