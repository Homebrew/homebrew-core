class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.13.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.13.tar.gz"
  sha256 "a1ab58f3148ba4b2674e938438166042137a9275bed747306641acfddc9ffb80"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lzlib/"
    regex(/href=.*?lzlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7680f6b9e88140a4127d37f2205fd3234d0317a1c544c0d95e4d7b11c3befc6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e209c35c3ebfda8ac9a4f010f4b67c2edb791023d8aad2798b759f7e62debeb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90f5f6d7704043f05267c00c988a5e72f383bfa3d68628c7a683b6177ea6e542"
    sha256 cellar: :any_skip_relocation, ventura:        "1e9c552f96203f479d1a841e8c56bf665fb1bbd3bd273e6038bfef3f9f9e976d"
    sha256 cellar: :any_skip_relocation, monterey:       "70694976deaa1ee867a7cda0aae5bef7055b001cdc654be21afa5d3327fd3b3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e87447e82af22377a309c648689820893e0add73356567e83e119a1bed9a28b"
    sha256 cellar: :any_skip_relocation, catalina:       "e60bfc9d982c3c40170a4f645a1466f9cc979f33b1a024ee9c2aa8e03d3597a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "443361cdf8e0ec75e738ed3b54298018a1b67e3635c660212d42187d5b3494e4"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdint.h>
      #include "lzlib.h"
      int main (void) {
        printf ("%s", LZ_version());
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-llz",
                   "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
