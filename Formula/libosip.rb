class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftp.gnu.org/gnu/osip/libosip2-5.1.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/osip/libosip2-5.1.0.tar.gz"
  sha256 "40573a997a656f967b2b5ebafbd36d7f1d4a4634abcf312643854057d061f145"

  bottle do
    cellar :any
    sha256 "5b8ab7e59d4c2e7daa9bfedecb74fabdb9a997c677d7f19fa55b48604cfe5d49" => :mojave
    sha256 "6a92bcb59772b46d9eba4e340f01cd798f54fcf521a6f6e09011c4f89c44d863" => :high_sierra
    sha256 "a6f031a29e43ee5af71d20f9c9b86bc138ad55a1c41faef1f2f852b5595912a8" => :sierra
    sha256 "b0a4712e735be9c798ba7f9233db9339a09dc70b69c88c318fc14662972f5511" => :el_capitan
    sha256 "01816d798919670ccce2726b59aa1752d4f6ef2a3e74df5e9141882c778e1f37" => :yosemite
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
