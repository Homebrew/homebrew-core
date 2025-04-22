class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/openmp-20.1.3.src.tar.xz"
  sha256 "cbe93aae254ed633a8e2e63a0fc0fc3a5a4a53745b511151bce4a4fde7d70397"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70ca0ae9df9f32ef88357ad35efa5b20ee8d91419e385fb0722e52605bceb03b"
    sha256 cellar: :any,                 arm64_sonoma:  "4fc242cbd0b57a00c22fc3d1f55bf8a9143f1a1aaecb7808092e044b1798e909"
    sha256 cellar: :any,                 arm64_ventura: "4f96c2d17c6ec12092109d1b8bb89333003529e645c0f5b7bb4f26b6c494dfd9"
    sha256 cellar: :any,                 sonoma:        "a2eff1984d704ae5b07ac1620268cf81f98221cf5f93ec71c5e7efabe9e42f36"
    sha256 cellar: :any,                 ventura:       "b0cf5645b4507eb577aad439eccda2a6cc929e786b6f289fb0305e20ba973b21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd3a7805112ed219cdf8c3ad67eea42e0423af80a452a3190fdfc140a0f0ca99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4acc1a2c159b09160f9423c7018c7d70f1732e991bb71f36dc5f5e4da52c4eed"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.13"
  end

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/cmake-20.1.3.src.tar.xz"
    sha256 "d5423ec180f14df6041058a2b66e321e4420499e111235577e09515a38a03451"

    livecheck do
      formula :parent
    end
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
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "-Werror", "-Xpreprocessor", "-fopenmp", "test.cpp", "-std=c++11",
                    "-I#{include}", "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end
