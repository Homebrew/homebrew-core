class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.2/openmp-18.1.2.src.tar.xz"
  sha256 "742dce34394d26f0916b5d3041cc737d4e41f5ee821d9fb054057f6f71cf9a2b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b7f124d2d57c77d4c85eb3b98ab429467f8f89f1e32116bca1f8ad3a0f94e7d"
    sha256 cellar: :any,                 arm64_ventura:  "0b9eaa1939489aeb6607afc906c5ef01133b40c53d3888e54ce78592cb5ccfb2"
    sha256 cellar: :any,                 arm64_monterey: "9651dfcbeb6f7700eeb1772e9b25497e3de62895a1d32a1965fc9f3bf318a783"
    sha256 cellar: :any,                 sonoma:         "3c9fb40cf22019a41a00207361a7f8b482f94c71bfe94dc0ce43411dc276cfc7"
    sha256 cellar: :any,                 ventura:        "a8897ab5a098177e71cd1af46f190d6664098aaee1cf06d58b95f9b6cd76f3ef"
    sha256 cellar: :any,                 monterey:       "009660e12c4527dc783b30f065304b37dbd0ddafa031023d08c17ce2f9046a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e789eb467fa8bbf75ed4080fb92d52db7171d40c0cfc8fad0167d1ac47544079"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.2/cmake-18.1.2.src.tar.xz"
    sha256 "b55a1eed9fe9c5d86c9f73c8aabde3e2407e603e737e1555545c3d136655955b"
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
