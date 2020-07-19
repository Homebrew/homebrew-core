class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.19.0.tar.gz"
  sha256 "cf3d6193fece9becddb62248b9981bf78cf1c7faf58150fd520d4755cd622488"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "3f0bd48f8086cb7ea76dfca4b61d702b91badee76faf05ceff514f795537c5af" => :catalina
    sha256 "da10033ade2963d8903182fe9f7b5f98f9064d0fcba9fd1b0ca00bacc23efb8f" => :mojave
    sha256 "83492ba1473b33ebbd54b0369bc67a904293e345a15f89ad7ba2a59039933b56" => :high_sierra
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
