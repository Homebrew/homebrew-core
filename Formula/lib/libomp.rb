class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.4/openmp-20.1.4.src.tar.xz"
  sha256 "544544a69a792f2b94e886cc556e8af85b50f1e30cf9f629718f4184439f9878"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "96254196dc1fc9a1acd54086ed6deb52d776befc75a3b786d0114d510e11b6b1"
    sha256 cellar: :any,                 arm64_sonoma:  "d5a42b450ea2ae7099e4a28581bb91f64f1d91b46ef1ba77bd51657c9751511b"
    sha256 cellar: :any,                 arm64_ventura: "8535d0e0e1402b4c857292d739c8118d97365b7923bdb3dc735a568ec10235f2"
    sha256 cellar: :any,                 sonoma:        "9a78864f40ec91badededf02bc5c9a0ab6012c59e429014f11f2de3aeb29a3be"
    sha256 cellar: :any,                 ventura:       "8274f5e0c96bd30b2e8fdf6900255c1b3aab2ec33b25a748eb9df50fb5f3cc2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a25283d4c4e63d6b13da3625ed21dde6a020271792cece1d3974b6cd72a9e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06843c4d96360de6de049ed9efd2a5375470b21e47b27065f55a7b03797dbb8b"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.4/cmake-20.1.4.src.tar.xz"
    sha256 "d6fe52e4fd709590284127cfef143f67ff1b917865f1b4731f6600c330bf9c27"

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
