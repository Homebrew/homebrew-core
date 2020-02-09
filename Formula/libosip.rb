class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftp.gnu.org/gnu/osip/libosip2-5.1.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/osip/libosip2-5.1.1.tar.gz"
  sha256 "61bb28317221a630e47f65389d5ff3e4693996d3128e9e0d5d1399e4feebf64d"

  bottle do
    cellar :any
    sha256 "7738fc68bf18445a8e9c1d3149507b2ac637a84f1094f4d75626552cdbe1d19c" => :catalina
    sha256 "1b8267b7239e9f690c214e0a789e0e6781242af462e4115452b19475a52cb57a" => :mojave
    sha256 "66e2807a297c1eeb853219def838b72a2eba7a8d95238040c26cc01377c5b5cf" => :high_sierra
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
