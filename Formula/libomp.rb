class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/openmp-15.0.7.src.tar.xz"
  sha256 "3f168d38e7a37b928dcb94b33ce947f75d81eef6fa6a4f9d16b6dc5511c07358"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "936d461ec7220ed45a5883ce20e7979ba2eeab48f9b5af69c7330ec1b8b95e7a"
    sha256 cellar: :any,                 arm64_monterey: "5c690eba8a95c37ec0f9c2052725e2a4dcf1c91fe8ee66a615f94365beb57608"
    sha256 cellar: :any,                 arm64_big_sur:  "39b3aaa82bb8ff80bc5bb22b78972320fed10d90fc075776516ca88ba335b235"
    sha256 cellar: :any,                 ventura:        "0854131fa75fd5b38bb7cce69e0597875b6859169bef0d99c905de8c22d9d51d"
    sha256 cellar: :any,                 monterey:       "0cda545ea3490f64d449e38ee6225c30e0952d8b25ce4ebe24cb8c559a513793"
    sha256 cellar: :any,                 big_sur:        "4cb1cec3b032fa4a0e19b64afa71afbe9cfb4a46dad54bf1c5d77340de388739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "127566b447d592f16c6a9e065660c5ad0ac6b7fa71f6583f06f9aaf49cd42da0"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/cmake-15.0.7.src.tar.xz"
    sha256 "8986f29b634fdaa9862eedda78513969fe9788301c9f2d938f4c10a3e7a3e7ea"
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
