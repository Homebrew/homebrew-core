class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.1/openmp-16.0.1.src.tar.xz"
  sha256 "3385718b1865c7a9ef45e8923a8e2487d23c20e1b8b4c18df6c5a2881eddf18a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4230f12e10e6bce7972bb43379cfd8e66ed0095c9a630438eca50e40b2ca0aa"
    sha256 cellar: :any,                 arm64_monterey: "f96a6bf9ebae2e427e75df282f82ae82d0decad680ae46ef68536dbb59889c96"
    sha256 cellar: :any,                 arm64_big_sur:  "702cc6cb27c0689e2c6d1ea62f8902309a3b2d32ffd0a52bf04436eda6553c23"
    sha256 cellar: :any,                 ventura:        "391287002a1787207ed313dfa2e8265368d743c8776802773ec54c5dbf786b12"
    sha256 cellar: :any,                 monterey:       "8cf8651a9dbdb41f15eb528db1457cbe237b4cce7ddd60d17ee80d785b1cd696"
    sha256 cellar: :any,                 big_sur:        "73660806aa10d00841c92312f22811ddc786142ad4303a23dfb5d9be6514d46a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe124e1f76b8c95a03df62d4aeaa59b3f3eb0ee608a8cd67730e0c0259da8b17"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.1/cmake-16.0.1.src.tar.xz"
    sha256 "f7b070b0ea71251c81b1a3dcdc6ccd28f59615e3e386c461456c5c246406acdc"
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
