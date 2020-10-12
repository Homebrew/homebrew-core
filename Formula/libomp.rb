class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/openmp-11.0.0.src.tar.xz"
  sha256 "2d704df8ca67b77d6d94ebf79621b0f773d5648963dd19e0f78efef4404b684c"
  license "MIT"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+.\d+.\d+)/i)
  end

  bottle do
    cellar :any
    sha256 "8545af588b2b210708b56669365cea97eb80941fe455e69f54ad85f3bb5bc18c" => :catalina
    sha256 "d410b199fed539dbd15de8f8fe98efc47067beca8d4271c0874ddc404567f65c" => :mojave
    sha256 "549d7af3d026fa160c96adfbda70b2ce4cd5f21710041d78bce4c1946b9bc2ec" => :high_sierra
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
