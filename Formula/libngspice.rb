class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/28/ngspice-28.tar.gz"
  sha256 "94804fa78c8db2f90f088902e8c27f7b732a66767a58c70f37612bff5a16df66"

  bottle do
    sha256 "62d5c4b9ee7a4126e7dfb18b3fd762c6d4b7325283702b58646d640a1c1773ec" => :mojave
    sha256 "ad14b322a63580cbee9940bb67546cce89d654072446cbb90bd75020f359e3f6" => :high_sierra
    sha256 "bfae0f3f17b4f5493b1c3dab4f2ad45f33d276d9da2ebe44ec68c808d5204ffb" => :sierra
    sha256 "81fa4c4a1da3fb720f921274fde37cdd540ffce16d6bec9c35bbae8399aa728c" => :el_capitan
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
