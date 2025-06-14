class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.7/openmp-20.1.7.src.tar.xz"
  sha256 "7d90b938728882dbfc332b37517c126bae35f2eaa4612e9b2999bf554a033b50"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1fb1e8332d85c6d13192dfa59f7ca35a181285b11b0f16161f373ce68ff8cdc"
    sha256 cellar: :any,                 arm64_sonoma:  "a71907c9a21978f9976fa254ee5b408d374249bf63222ebcb1aeea21aa271cef"
    sha256 cellar: :any,                 arm64_ventura: "f8969e090ae2a5376f5d4758bfdeee6dc5bcc61db5e4b8c979377bcf714213b7"
    sha256 cellar: :any,                 sonoma:        "84d7ae40495b53e9ba363e1482c0c72bd0ff159c9382070363643cc8103a58dc"
    sha256 cellar: :any,                 ventura:       "6d0de17c559df28a7e979e8e163d218386b42f2d1ce05729fbbf35b016f31a9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4ba5b242b0ed452c3e2ebdb348991076ba654c10676f4a8134f55722aa6bfa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "071afda31d081137d741093d99ecb44f38e3728278b1351d3e24015d800e5ebc"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.7/cmake-20.1.7.src.tar.xz"
    sha256 "afdab526c9b337a4eacbb401685beb98a18fb576037ecfaa93171d4c644fe791"

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
