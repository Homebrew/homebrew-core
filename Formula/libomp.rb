class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://releases.llvm.org/5.0.1/openmp-5.0.1.src.tar.xz"
  sha256 "adb635cdd2f9f828351b1e13d892480c657fb12500e69c70e007bddf0fca2653"

  bottle do
    cellar :any
    sha256 "b979a1127556d48732079825ee9386df0454124b86062a1bbd9dfce4cc15e80c" => :high_sierra
    sha256 "9e869b95916c6246647f5ff75e0e117d47ba7cdde5c6d408f46e4535c2e848ec" => :sierra
    sha256 "f3b27cb2f45233a981b9a9cd62ab77fb0935857ec4b7b386c17485be1f9f6f39" => :el_capitan
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
