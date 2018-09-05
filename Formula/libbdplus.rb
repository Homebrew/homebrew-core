class Libbdplus < Formula
  desc "Implements the BD+ System Specifications"
  homepage "https://www.videolan.org/developers/libbdplus.html"
  url "https://download.videolan.org/pub/videolan/libbdplus/0.1.2/libbdplus-0.1.2.tar.bz2"
  mirror "https://ftp.osuosl.org/pub/videolan/libbdplus/0.1.2/libbdplus-0.1.2.tar.bz2"
  sha256 "a631cae3cd34bf054db040b64edbfc8430936e762eb433b1789358ac3d3dc80a"

  bottle do
    cellar :any
    sha256 "d8f4b53ec0ea12bbc02b2962e94dfe5df98ef55005f10209f4fd40213a80f601" => :mojave
    sha256 "478e405b0f9687edcea3f651f4ec922a1bd12c12476c3aa14d1a35d0bb0362bb" => :high_sierra
    sha256 "8205ed5218393f7aa7f2035f089e91a417f13d73f4b7e3d46f3afc5073ce7e37" => :sierra
    sha256 "7136cdf433318efb9691d43d078eb20e9647f2ae4999b42cf791736d95047a81" => :el_capitan
    sha256 "13f271c0bb73d496cda7314d6665478c19193f0eb3b9b7a9fbc1eb4a957894c9" => :yosemite
    sha256 "e2189073d60ed520ed852355aebf1a5137fec5bead346ebc68f2b202d495db36" => :mavericks
  end

  head do
    url "https://git.videolan.org/git/libbdplus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libbdplus/bdplus.h>
      int main() {
        int major = -1;
        int minor = -1;
        int micro = -1;
        bdplus_get_version(&major, &minor, &micro);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lbdplus", "-o", "test"
    system "./test"
  end
end
