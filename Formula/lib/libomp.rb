class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.2/openmp-17.0.2.src.tar.xz"
  sha256 "782d55cc576ac9ac25120325c4faae3825531835c7948a732fe5f40a1fc77ce1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e3db02bfe45aad2bdf2c506da02e6dc133cf321e3d57e097ba5271f89a0ba1d"
    sha256 cellar: :any,                 arm64_ventura:  "e6b335292e831a4722e953c6a17627e0fcfc6bc2c6e9fd629037fd1e6c945656"
    sha256 cellar: :any,                 arm64_monterey: "1e1c3b72b4ad532a9d03ab9411219add8f7d050cb962bfcd48137a830f8584a6"
    sha256 cellar: :any,                 sonoma:         "72d46a4bc5ff5cee808e99a3ba1beca9bb2e2a3035753e7f8dcaa9471429f56d"
    sha256 cellar: :any,                 ventura:        "130ce4420142d7bc8c246f6bdfe1f0f832a5c948843ff9530ab5dc7b3c182e98"
    sha256 cellar: :any,                 monterey:       "1a274d0205407af0f98b9808fb940ea063af41ef1913139e069f1607c1e60562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9ef310e67e0fa03e1210829b6daf89271b82f53ba8c5963e7425d2059134978"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.2/cmake-17.0.2.src.tar.xz"
    sha256 "07093ef3b47bc30c24c8ab4996dea8c89eb6f3c8f55cd43158000c61c1fd5075"
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
