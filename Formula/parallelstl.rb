class Parallelstl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https://github.com/intel/parallelstl"
  url "https://github.com/intel/parallelstl/archive/20191218.tar.gz"
  sha256 "cdbf051df6d9399a1756bd94a87c4e083fff144703aff561b608012653ce3a2c"

  bottle :unneeded

  depends_on "tbb"

  def install
    include.install Dir["include/*"]
    (prefix/"stdlib").install Dir["stdlib/*"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pstl/execution>
      #include <pstl/algorithm>
      #include <array>
      #include <assert.h>

      int main() {
        std::array<int, 10> arr {{5,2,3,1,4,9,7,0,8,6}};
        std::sort(std::execution::par_unseq, arr.begin(), arr.end());
        for(int i=0; i<10; i++)
          assert(i==arr.at(i));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-L#{Formula["tbb"].opt_lib}", "-ltbb",
                    "-I#{prefix}/stdlib", "-I#{include}", "test.cpp", "-o", "test"
    system "./test"
  end
end
