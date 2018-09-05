class Libuecc < Formula
  desc "Very small Elliptic Curve Cryptography library"
  homepage "https://git.universe-factory.net/libuecc/"
  url "https://git.universe-factory.net/libuecc/snapshot/libuecc-7.tar"
  sha256 "0120aee869f56289204255ba81535369816655264dd018c63969bf35b71fd707"
  head "https://git.universe-factory.net/libuecc"

  bottle do
    cellar :any
    sha256 "d4d0c41262688ddca9ee2f2e6b80c33670c5a8db7266cd0c0592cd50b0d18be1" => :mojave
    sha256 "95646c23acf19c1f07032c6f311f446e7a32b1a9d0c1dd385ec3c41811036572" => :high_sierra
    sha256 "4722877fdc4538c814a10e6d0dc2f1a4d2a3571ce4ca1c8b37279c88cd83883f" => :sierra
    sha256 "d9e52027a6535fb74e44026d23ef13a2417a1f22402173dc90d136071ea5290d" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <libuecc/ecc.h>

      int main(void)
      {
          ecc_int256_t secret;
          ecc_25519_gf_sanitize_secret(&secret, &secret);

          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "-I#{include}/libuecc-#{version}", "-L#{lib}", "-o", "test", "test.c", "-luecc"
    system "./test"
  end
end
