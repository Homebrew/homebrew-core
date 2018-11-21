class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://releases.llvm.org/7.0.0/openmp-7.0.0.src.tar.xz"
  sha256 "30662b632f5556c59ee9215c1309f61de50b3ea8e89dcc28ba9a9494bba238ff"

  bottle do
    cellar :any
    sha256 "dbaecca3bef86692ab838e66ab605ee75b5d1cd08350b06a28177c17b2859762" => :mojave
    sha256 "046f659ad8a2cc336049a1e7f7be0dac2f2e28ce322409f10396f9582b94b660" => :high_sierra
    sha256 "ba1b9a78326c671fb864a95d93f2fcf47f3af2ef8f12f6c7ee54a7c0cf7802b4" => :sierra
    sha256 "0ea5b6ae3e9e0b32a2b49a7430fb0f653430107164089b067a7b0039e91ce527" => :el_capitan
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
