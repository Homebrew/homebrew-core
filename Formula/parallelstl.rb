class Parallelstl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https://github.com/intel/parallelstl"
  url "https://github.com/intel/parallelstl/archive/20200330.tar.gz"
  sha256 "47d78920a7220828cde9b0c0cf808c70774b2db05ab4dd689b8bbd350afb9e6e"

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
