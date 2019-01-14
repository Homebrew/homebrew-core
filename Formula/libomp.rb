class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://releases.llvm.org/7.0.0/openmp-7.0.0.src.tar.xz"
  sha256 "30662b632f5556c59ee9215c1309f61de50b3ea8e89dcc28ba9a9494bba238ff"

  bottle do
    cellar :any
    sha256 "c8788028105e9ec32e29bcdba8c7b550c2afd96b3f0a7bd0d6b6136a8729174a" => :mojave
    sha256 "24072de1910b63d6047685bafc3e44e5d65686d04555a5239fc6d0410fb4eed2" => :high_sierra
    sha256 "2aad5e93e8c4548fd66a70782f1a9e1dbdb662a6497a267d317f297f73ea22aa" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :macos => :yosemite

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "cmake", ".", "-DLIBOMP_ENABLE_SHARED=OFF", *std_cmake_args
    system "make", "install"
  end

  def caveats; <<~EOS
    On Apple Clang, you need to add several options to use OpenMP's front end
    instead of the standard driver option. This usually looks like
      -Xpreprocessor -fopenmp -lomp

    You might need to make sure the lib and include directories are discoverable
    if #{HOMEBREW_PREFIX} is not searched:

      -L#{opt_lib} -I#{opt_include}

    For CMake, the following flags will cause the OpenMP::OpenMP_CXX target to
    be set up correctly:
      -DOpenMP_CXX_FLAGS="-Xpreprocessor -fopenmp -I#{opt_include}" -DOpenMP_CXX_LIB_NAMES="omp" -DOpenMP_omp_LIBRARY=#{opt_lib}/libomp.dylib
  EOS
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <omp.h>
      #include <array>
      int main (int argc, char** argv) {
        std::array<size_t,2> arr = {0,0};
        #pragma omp parallel num_threads(2)
        {
            size_t tid = omp_get_thread_num();
            arr.at(tid) = tid + 1;
        }
        if(arr.at(0) == 1 && arr.at(1) == 2)
            return 0;
        else
            return 1;
      }
    EOS
    system ENV.cxx, "-Werror", "-Xpreprocessor", "-fopenmp", "test.cpp",
                    "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end
