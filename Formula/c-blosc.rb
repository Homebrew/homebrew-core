class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "http://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.15.0.tar.gz"
  sha256 "dbbb01f9fedcdf2c2ff73296353a9253f44ce9de89c081cbd8146170dce2ba8f"

  bottle do
    cellar :any
    sha256 "aa0de6ae3d63afb0cda8bbbeaca4054824ffa2b0b867483a3caaacd66a3df7d4" => :mojave
    sha256 "bd14b41fb53c17079390fd135b9371a426d789cdd612571af851f57dc6f1c287" => :high_sierra
    sha256 "a9c9839ef114be41250c9dcffe11ee6991ce2e6a300ebc8418d5013d6f15aedf" => :sierra
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
