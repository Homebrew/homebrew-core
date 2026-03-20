class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.7.0/libxmp-lite-4.7.0.tar.gz"
  sha256 "69967a7802d2d2f938347f6f9cd95232bf45a4623cbfcc196e37cdaefadc3974"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "201ea45ab0fd62dbebb197abfb1ff8489d75b62b98556eb55393e7ce46909938"
    sha256 cellar: :any,                 arm64_sequoia: "3b0101130351878977713c358a85efc5aeba42ff6020c0937fcfab1ef370d325"
    sha256 cellar: :any,                 arm64_sonoma:  "6eb64812621b57dec829e8c6a539c8d4b00d560588ae73d321f070ae772427ab"
    sha256 cellar: :any,                 sonoma:        "cce627af00de3a26e520f4e359465d34ba615e0c184c30637627bc25ab7a6a1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dfa89164cbb60ee10d098a68f7677fd6d7b0f4e9c62827297d6e3250628d794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e20f182fa8f91177086c114ceed9ee5fb0271ac8a0e1a5ea734e5f13a600893"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <libxmp-lite/xmp.h>

      int main(int argc, char* argv[]){
        printf("libxmp-lite %s/%c%u\\n", XMP_VERSION, *xmp_version, xmp_vercode);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxmp-lite", "-o", "test"
    system "./test"
  end
end
