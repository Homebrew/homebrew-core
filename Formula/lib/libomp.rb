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
    sha256 cellar: :any,                 arm64_sequoia: "70e6da25205323438aaadfb030b49d439c188ab188cc57e6eff055352395df1d"
    sha256 cellar: :any,                 arm64_sonoma:  "a93e7a009eb8580ff409981d8e894c04ec09759264052ec45e974246d525ba41"
    sha256 cellar: :any,                 arm64_ventura: "e2061a83c7ed235a92317e445279093aacf53e9e7a8e123c265488ea56755935"
    sha256 cellar: :any,                 sonoma:        "695f5060a7b58bd42d069a442d01671a3d5894d1c5909903c0b1e389430f65cb"
    sha256 cellar: :any,                 ventura:       "9f1809860b2d62178215af994cfcb5fd8b53c831e61a1b412c35af386a01bd74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84adbcda8e7d767740b2a5dea255d1846bc666e36412657ab3c094372fc65c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdae5020d54d83998041d8568a09a9fec423c60651d3768c243bb91fd868c3e5"
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
