class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://www.blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.21.3.tar.gz"
  sha256 "941016c4564bca662080bb01aea74f06630bd665e598c6f6967fd91b2e2e0bb6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "64e4fb9e5fd5b8c169fc4c9bbba1f9bb191a588076b41ddfb367f9530ab9e17a"
    sha256 cellar: :any,                 arm64_monterey: "5aa57f0f4c9c5a80cdf122b2e81c5d4672856fc940cb22641079e191eb106cf3"
    sha256 cellar: :any,                 arm64_big_sur:  "202ee885644b5c5ddc1308ac242fd2d9694051427adb35bf5146c906db4e604b"
    sha256 cellar: :any,                 ventura:        "8680891bced00c036ceaebe8d5109dfb1b8250c7ef98e17b1c638fd03a1e913c"
    sha256 cellar: :any,                 monterey:       "2d73d21ed8b60da778bb62ded3fa54293b03f5217a8962add7c577eaaf7aeda0"
    sha256 cellar: :any,                 big_sur:        "2c54691a508448087c34fc17ac5e9829b3a5abc2522a24512bfa4ca684d0a06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b37c85e68e07e07c39179799cab07ebf2841fa2441a64a76a15b14dfe167bb7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <blosc.h>
      int main() {
        blosc_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lblosc", "-o", "test"
    system "./test"
  end
end
