class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.3/openmp-17.0.3.src.tar.xz"
  sha256 "e04172c067f256d06cd8112abb49bc65f4e1d986a4b49b36cd837dfee3cdd274"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8a1a347489d17c9bf9873d36ddd0f82a1f7d35feab2d9fa7aa0b03dba94a6d03"
    sha256 cellar: :any,                 arm64_ventura:  "149d541227b1f1dad5c67f185e60cbd97418b6878469acf94f833b7c10caae10"
    sha256 cellar: :any,                 arm64_monterey: "327c05a5fcbaac103708a7583a3fc4b8e63a17f1139031c8cc5483c6214a9456"
    sha256 cellar: :any,                 sonoma:         "faee7227d2d64f1d7cd614a28dc98f39539735f34d005428db9ce3e1bd7b7305"
    sha256 cellar: :any,                 ventura:        "f04651e5cc8981321bf93314b5e05ce9085c19ac36339f09e4cf39542108ad4b"
    sha256 cellar: :any,                 monterey:       "08a40429677e35b26f4b1f8b1841177e2aba02dc131d245758e81e6e9c8cbfd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01a8fd3ab8e21feb7fcca9dca09393028a086568e2b265586c1b59cbd19a761d"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.3/cmake-17.0.3.src.tar.xz"
    sha256 "54fc534f0da09088adbaa6c3bfc9899a500153b96e60c2fb9322a7aa37b1027a"
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
