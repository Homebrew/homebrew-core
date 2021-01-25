class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "https://research.wand.net.nz/software/libprotoident.php"
  url "https://research.wand.net.nz/software/libprotoident/libprotoident-2.0.13.tar.gz"
  sha256 "8ca7ccd95b3f23457c3f9eff480364565b553bbcab9b39969f964910738e5672"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?libprotoident[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "5150fd5fc726b744ffd474d2c9b6407014df45a2080cb034d82156c3f20c3d9b" => :big_sur
    sha256 "ca534b9c4ed21b9704262f4c334c7ff42453c803c876b819f48ea6b26a4941d2" => :arm64_big_sur
    sha256 "f7bdcc25564854f28b3a0c308bcad5d17f71f186c05b8ab356752c9d0d11f31b" => :catalina
    sha256 "47e13c727609ab739bb59a74232870ba82ddb2ce8c4e5b145f3e92fc3383edd6" => :mojave
    sha256 "2be3c3bcd3b921e264a9bf8ff730d95af2d3a8aee252d849aba1b88d30d49892" => :high_sierra
  end

  depends_on "libflowmanager"
  depends_on "libtrace"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libprotoident.h>

      int main() {
        lpi_init_library();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lprotoident", "-o", "test"
    system "./test"
  end
end
