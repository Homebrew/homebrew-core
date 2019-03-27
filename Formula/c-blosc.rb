class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "http://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.16.3.tar.gz"
  sha256 "bec56cb0956725beb93d50478e918aca09f489f1bfe543dbd3087827a7344396"

  bottle do
    cellar :any
    sha256 "18075b1efb8dcabda3ca5da07ebdf155b80f9f2df4b39512a071a935cc754480" => :mojave
    sha256 "ee11e9eb9d57b4f4bc2d8a9428634ce8173463a1954dfe29840a9b0e132bf76e" => :high_sierra
    sha256 "af1d161ab442531dfd6a594a19895c05dc292047c9054588879674912aba6e96" => :sierra
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
