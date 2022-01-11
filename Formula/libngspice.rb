class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"

  stable do
    url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/36/ngspice-36.tar.gz"
    sha256 "4f818287efba245341046635b757ae81f879549b326a4316b5f6e697aa517f8c"

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
    sha256 cellar: :any,                 arm64_monterey: "9d58e20b687ede651ca723c47a35bbc772478ab75768159021b38cb3d2f70a91"
    sha256 cellar: :any,                 arm64_big_sur:  "06bfd009199b8955829ee232e8af51d8f5d9f18251cdfff08f957ec3cb5d4ee9"
    sha256 cellar: :any,                 monterey:       "31d9faaad4c639bb2b16330c68bd9345df81cecc91946cf2f579ab2725ff11e0"
    sha256 cellar: :any,                 big_sur:        "6234e617fda518242b252264e3ffdfab258711469adfdfbdf6586bb50e1776fe"
    sha256 cellar: :any,                 catalina:       "f3d15531e93ab0c0bd4c19a17e85c1474352d04fbcd8c6592f11b687a8474138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "179a9d7162f4dbda06ff91e35c6775cff85fcc40ff6cb65929be8bfa15823734"
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
