class Libuecc < Formula
  desc "Very small Elliptic Curve Cryptography library"
  homepage "https://git.universe-factory.net/libuecc/"
  url "https://git.universe-factory.net/libuecc/snapshot/libuecc-7.tar"
  sha256 "0120aee869f56289204255ba81535369816655264dd018c63969bf35b71fd707"

  head "https://git.universe-factory.net/libuecc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a0c1d14eea13345e2b801843b88c343812b9a8ad277538b103e9c52970c06461" => :high_sierra
    sha256 "d6108e008f03c69ef2f76443a7bfecd9262bd3ba03613f24c56d4fd921c73c85" => :sierra
    sha256 "ed13876ca85617cfe1f6fd174ebd4502d29096d2b8c4bcaf3facc9749f28ae34" => :el_capitan
    sha256 "eb7bcbd632f8f5f1faedbbe49529a9b1820d31530b5a256558d4e99edc2953e1" => :yosemite
    sha256 "dfdb783678a0aa3a8edd745d890921b8213f3e1075d152a13a207053e178e270" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
