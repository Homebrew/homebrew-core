class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.1/openmp-12.0.1.src.tar.xz"
  sha256 "60fe79440eaa9ebf583a6ea7f81501310388c02754dbe7dc210776014d06b091"
  license "MIT"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9b4d71ac4e8a8b8d04819b1bfd155bcb266a9fdf1405b24c9e3801858b08d8bf"
    sha256 cellar: :any,                 big_sur:       "cba5086bd24f1aaa196900f784d7cf1c3dc0de1f536db2f6dccf571a7850d5d9"
    sha256 cellar: :any,                 catalina:      "1c84ee05772f5a01ddfbb9ad56c5e1526a5f6fee48b3eeeb732352b9a35fa5d3"
    sha256 cellar: :any,                 mojave:        "bb25a639e722fe6ab1ede965a5a8854696f40daac2c9c69ad36a8be7f8ae2606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "732e9e28300c5e0b3fe8de12e5b6617bc8bb39cc401d5a35cffbb305097a70e9"
  end

  depends_on "cmake" => :build

  on_linux do
    keg_only "provided by LLVM, which is not keg-only on Linux"
  end

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
    system ENV.cxx, "-Werror", "-Xpreprocessor", "-fopenmp", "test.cpp", "-std=c++11",
                    "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end
