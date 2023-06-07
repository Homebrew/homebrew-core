class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/openmp-16.0.5.src.tar.xz"
  sha256 "bc15dc5b3c77f4c441f3a0c386befaa6a2f911e090740c062d2ebcabf52f4c52"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6c62909e4378e4e40659db2cda7a00278ea044cd882018deeec202dce9b95f3f"
    sha256 cellar: :any,                 arm64_monterey: "53a66dac03eb9f4c5ac3ed181281b790fae8060b567939d08c02903e1518a95b"
    sha256 cellar: :any,                 arm64_big_sur:  "a4f2016079e0426c906364a5d9bcf3e33205f0236f9aef8599a150e91326bbf1"
    sha256 cellar: :any,                 ventura:        "8bc46a0a3aeaad084ed56d8d325d41166bc14e58a5147fe79d211681b05e4d88"
    sha256 cellar: :any,                 monterey:       "6a63bdf68a4ff559150c5be8d233a210d41c3b471790854c0d3e284953e792a5"
    sha256 cellar: :any,                 big_sur:        "457e2e5f632b16407f8d619aba7abb0469b3809b8776d40e4d2e1347f66b4a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8683a8cd232054fb74a26a12e0940c503382c54038e352b0cdb41937438f817"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.11"
  end

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/cmake-16.0.5.src.tar.xz"
    sha256 "9400d49acd53a4b8f310de60554a891436db5a19f6f227f99f0de13e4afaaaff"
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
    assert_equal version, resource("cmake").version, "`cmake` resource needs updating!"
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
