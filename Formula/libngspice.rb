class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/28/ngspice-28.tar.gz"
  sha256 "94804fa78c8db2f90f088902e8c27f7b732a66767a58c70f37612bff5a16df66"

  bottle do
    sha256 "f1470393444748a5fb604cdadc7974402753827cca715f1588508fd7305c8d30" => :high_sierra
    sha256 "841be3e66bf1f3dd18a74f2dfd201b95acebfd32e1bd180d99037193e3437bf3" => :sierra
    sha256 "ef9fab04fd5b79cc361fa14642b59d762c7f589ea37c22e41273e97841712537" => :el_capitan
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
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
      "--disable-dependency-tracking", "--with-ngshared", "--enable-cider",
      "--enable-xspice"
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
