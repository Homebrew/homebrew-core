class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://releases.llvm.org/9.0.0/openmp-9.0.0.src.tar.xz"
  sha256 "9979eb1133066376cc0be29d1682bc0b0e7fb541075b391061679111ae4d3b5b"

  bottle do
    cellar :any
    sha256 "d069252a4b6ab3e09be573be43233887446a1f49bf6b9f0b8c6752c650ffc1c4" => :mojave
    sha256 "aea4ed170e1fbb524397ea0dfb4033be9fac6d00619320f9b3a60880df7493f7" => :high_sierra
    sha256 "7bf1bce14309673ce873e152a5a3dd717a1a192b34e7fd8fdfd25560e8b16e6e" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :macos => :yosemite

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
