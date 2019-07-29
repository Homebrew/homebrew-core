class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftp.gnu.org/gnu/osip/libosip2-5.1.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/osip/libosip2-5.1.0.tar.gz"
  sha256 "40573a997a656f967b2b5ebafbd36d7f1d4a4634abcf312643854057d061f145"

  bottle do
    cellar :any
    sha256 "48927b88f3bbbf374d17f42111c2742ee9687e2f98174724122bdb0859cff495" => :mojave
    sha256 "a5491521463dac7678b0f33c154134eeb6c197ffd17e12045118a108826580a5" => :high_sierra
    sha256 "123835319f7fcc3bf04dc8bec0204256e53685ef29f179226c98f4a6abe0c1b5" => :sierra
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
