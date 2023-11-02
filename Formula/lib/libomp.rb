class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.4/openmp-17.0.4.src.tar.xz"
  sha256 "535cbcca075430cb2d4e54a8062cb9646938170aeb72d359f13183f2a31b701a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "01da721e317857fab496df7854267c48c81979f0abc9420f072aae71bf3fc2d5"
    sha256 cellar: :any,                 arm64_ventura:  "f69d9d8029a1584fb14fb1caf7c7282f9cc9f883c2434e83cb37dfee3774dab5"
    sha256 cellar: :any,                 arm64_monterey: "ee581289c4094473da0b1d775d8b5c3e11beaa85286b50b0b9d9401325298a79"
    sha256 cellar: :any,                 sonoma:         "723e33b6616171e43ec3e04b82095cbc3cae569cce935d17238bf5314662d101"
    sha256 cellar: :any,                 ventura:        "f506dc61dfac9a4380bf84464fce8ccc8998a6821a7c567d8596d503648687fd"
    sha256 cellar: :any,                 monterey:       "36a55897bc6058ab4b55555c456ae5890ed5fc2f97566792a0aaed3277f44e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78e1f50a8459a25f61d9f7031899d699063d5df68d593f200c4d26723ab07884"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.4/cmake-17.0.4.src.tar.xz"
    sha256 "1a5cbe4a1fcda56ecdd80f42c3437060a28c97ec31de1748f6ba6aa84948fb0f"
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
