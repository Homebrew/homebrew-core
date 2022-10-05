class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.2/openmp-15.0.2.src.tar.xz"
  sha256 "2567c5ed2b2d3343a0f3b2d5a4dd116a37776d60c880aa2b0c3313a7f68ba4d8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b36b1393289e7d98fc03425b6c23a63c4f5e9290ecf0922d45e6fde2973ba8fb"
    sha256 cellar: :any,                 arm64_big_sur:  "f00a5f352167b2fd68ad25b1959ef66a346023c6dbeb50892b386381d7ebe183"
    sha256 cellar: :any,                 monterey:       "a423e0bc90a9d0f0feff08eb197768287ba4722b88d4624c2d8306e443ff6fdb"
    sha256 cellar: :any,                 big_sur:        "46e5838f0061cfe1901c485987fc5649464cfa3b2150f2ac54dd5e61eb3342a4"
    sha256 cellar: :any,                 catalina:       "63cdbb3a70c4b85a6a92a55c8ab2384ded244d37568cd769409dee00a14b581d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "470c1338f8c1bc8ef1a41e86bb9beddcff9c353947a2073b2c2b4f584db9bd20"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.2/cmake-15.0.2.src.tar.xz"
    sha256 "c47c4d54bb311298abe97e7d8e8185eaa8d71feb6d85e5e38356a70679e5c61e"
  end

  def install
    (buildpath/"src").install buildpath.children
    (buildpath/"cmake").install resource("cmake")

    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    args = ["-DLIBOMP_INSTALL_ALIASES=OFF"]
    args << "-DOPENMP_ENABLE_LIBOMPTARGET=OFF" if OS.linux?

    system "cmake", "-S", "src", "-B", "build/shared", *std_cmake_args, *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "src", "-B", "build/static",
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
                    "-I#{include}", "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end
