class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftp.gnu.org/gnu/osip/libosip2-5.1.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/osip/libosip2-5.1.2.tar.gz"
  sha256 "2bc0400f21a64cf4f2cbc9827bf8bdbb05a9b52ecc8e791b4ec0f1f9410c1291"

  livecheck do
    url :stable
    regex(/href=.*?libosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "b965f0c2b0b623a011a7e3e4e0f9b08f96eb7483355bc7e64f658ababaec3b79" => :catalina
    sha256 "d73e3fe7539d664ec53c869fcf53f26716258c685174abfad73e17416f2128d4" => :mojave
    sha256 "7cba1e2b5785ec2702f01cb17cb64ad839e221019724e080825c4c57a14bc08a" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sys/time.h>
      #include <osip2/osip.h>

      int main() {
          osip_t *osip;
          int i = osip_init(&osip);
          if (i != 0)
            return -1;
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-losip2", "-o", "test"
    system "./test"
  end
end
