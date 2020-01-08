class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/31/ngspice-31.tar.gz"
  sha256 "845f3b0c962e47ded051dfbc134c3c1e4ac925c9f0ce1cb3df64eb9b9da5c282"

  bottle do
    sha256 "65990d8ecfe7fea7f7be728ac3783b2df7efd321e4b1fb4f50b9f5491fa47dc3" => :catalina
    sha256 "b1693830a58945c577baa5bab6d97df12cc429409d938a5dae333c9a9059dcd8" => :mojave
    sha256 "b44b359c37d2ce7c60bee9597e880cf5190e25c1145c4a92f93b9f7572ad9a1e" => :high_sierra
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
