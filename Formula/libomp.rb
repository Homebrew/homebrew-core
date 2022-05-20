class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/openmp-14.0.0.src.tar.xz"
  sha256 "28a1cbdd3dfdd331e4ed2dda2b4477fc418e455c883bd0d1d6acc331118e4688"
  license "MIT"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cf1058b26e1a778e523d51562c99b4145aea1b1cb89f1c60b3315677a86c7a08"
    sha256 cellar: :any,                 arm64_big_sur:  "bbf77a1a151f00a18e340ab1f655fb87fe787a85834518f1dc44bf0c52ae7d4c"
    sha256 cellar: :any,                 monterey:       "e66d2009d6d205c19499dcb453dfac4376ab6bdba805987be00ddbbab65a0818"
    sha256 cellar: :any,                 big_sur:        "ed9dc636a5fc8c2a0cfb1643f7932d742ae4805c3f193a9e56cab7d7cf7342e7"
    sha256 cellar: :any,                 catalina:       "c72ce9beecde09052e7eac3550b0286ed9bfb2d14f1dd5954705ab5fb25f231b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fe14d5f4c8b472de1fad74278da6ba38da7322775b8a88ac61de0c373c4ad10"
  end

  depends_on "cmake" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    keg_only "provided by LLVM, which is not keg-only on Linux"
  end

  def install
    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    args = ["-DLIBOMP_INSTALL_ALIASES=OFF"]
    args << "-DOPENMP_ENABLE_LIBOMPTARGET=OFF" if OS.linux?

    system "cmake", "-S", "openmp-#{version}.src", "-B", "build/shared", *std_cmake_args, *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "openmp-#{version}.src", "-B", "build/static",
                    "-DLIBOMP_ENABLE_SHARED=OFF",
                    *std_cmake_args, *args
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"
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
