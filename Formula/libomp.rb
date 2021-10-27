class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/openmp-13.0.0.src.tar.xz"
  sha256 "4930ae7a1829a53b698255c2c6b6ee977cc364b37450c14ee458793c0d5e493c"
  license "MIT"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2a7253a4e9ff0ed48b1ea2cf98f953d17a28037ce3b9cbfb22c0c733918e22e4"
    sha256 cellar: :any,                 arm64_big_sur:  "13fb59602f7b525b38416cad3661743d178ca8ef7f817b37306842b58510020e"
    sha256 cellar: :any,                 monterey:       "fe1a6935e1da396268818c653a8fa8c56f34fca1e46636dd95605110cbf8446c"
    sha256 cellar: :any,                 big_sur:        "be00288f6f2901b633774b5a3127302a34ef0c9ab0588116d0193be2a627683d"
    sha256 cellar: :any,                 catalina:       "fe6c16f6998e7648b201f461746fb8466324b6eb1184d3ac5ae55a7793f74b91"
    sha256 cellar: :any,                 mojave:         "145870f8ede6328f26d81b6aa92980b9b74671b36c6f440b02a4ebae39f55239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40e753d319aa1c0d3f41199f03e91f2a409b9df74eee5503a4ab3967aadeb8b0"
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

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
    system "cmake", ".", "-DLIBOMP_ENABLE_SHARED=OFF", *std_cmake_args, *args
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
