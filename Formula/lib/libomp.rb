class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.8/openmp-18.1.8.src.tar.xz"
  sha256 "60ed57245e73894e4a2a89b15889f367bd906abfe6d3f92e1718223d4b496150"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "697ee21826162653faddf3c7eb7810ee90cbdaad1a2f07019b8824e4113094b8"
    sha256 cellar: :any,                 arm64_ventura:  "dce27dc860127be3aa739a30496efe474f80ee7c8927d26ac7e3985f45a2f46b"
    sha256 cellar: :any,                 arm64_monterey: "a1953d256b69b0b29cb1b2f933a15878ef9cfa8caf5f8c439ce4d4a8d6892ca3"
    sha256 cellar: :any,                 sonoma:         "8b1ba704e73036c4e844193d67fe537534aa2901006cbaca25315fac3cdfcb95"
    sha256 cellar: :any,                 ventura:        "6acfa701a4c5a2256a6996f669b81a494626f635a1366cca25d7cfff5b8142f8"
    sha256 cellar: :any,                 monterey:       "0f1883c4651a04259281cc0fb4791effe7ab409a0d55d62fdd16435bf4d7e61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7a55a0b85f9e65bb3d14b5acad4876509a312ed78f03cddf76ba75ec65e77a3"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.12"
  end

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.8/cmake-18.1.8.src.tar.xz"
    sha256 "59badef592dd34893cd319d42b323aaa990b452d05c7180ff20f23ab1b41e837"
  end

  def install
    odie "cmake resource needs to be updated" if version != resource("cmake").version

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
