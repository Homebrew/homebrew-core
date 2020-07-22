class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/openmp-10.0.0.src.tar.xz"
  sha256 "3b9ff29a45d0509a1e9667a0feb43538ef402ea8cfc7df3758a01f20df08adfa"
  license "MIT"

  bottle do
    cellar :any
    sha256 "0ea757dbea7bf12141ef1d209d2f3b59919baa0caa0482d7ea6ae9c2dfed2382" => :catalina
    sha256 "aecd306b605763dbd06c73b5d470c924643b48c051f06d8a4e70be705052c8ee" => :mojave
    sha256 "ddfbe1ab7c6dafc45c787d6b4ae19fffb6465bbc0aef007b728cb98ba0d6d2b1" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    system "cmake", ".", *std_cmake_args, "-DLIBOMP_INSTALL_ALIASES=OFF"
    system "make", "install"
    system "cmake", ".", "-DLIBOMP_ENABLE_SHARED=OFF", *std_cmake_args,
                         "-DLIBOMP_INSTALL_ALIASES=OFF"
    system "make", "install"
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
