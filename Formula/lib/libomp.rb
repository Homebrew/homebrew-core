class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.8/openmp-20.1.8.src.tar.xz"
  sha256 "b21c04ee9cbe56e200c5d83823765a443ee6389bbc3f64154c96e94016e6cee9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e2e7b434187fffff654343b29a1d108a901d19eb5de892bb3ead7d72fdd0ddf"
    sha256 cellar: :any,                 arm64_sonoma:  "b95598b923b53ec9d9168310c37f65bdcaae75e63cc8f54bc86d97f53f6d3acc"
    sha256 cellar: :any,                 arm64_ventura: "deb20952edcae9865747cb69344728694bf593db8e8a209f7a390fb20bf46643"
    sha256 cellar: :any,                 sonoma:        "9eb4b7dfae5bc0d850228b686b3157ecd8c596c9cd70893f7ab1544fcde4ff39"
    sha256 cellar: :any,                 ventura:       "e918a431238234858ddab33d4ac383d4b33328ed0b5ac3e0cc0bb248e2076547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca71b24f233aedd2965cfaf7a9ea5e616f1f0dd2a23937317302dc2784ad66db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd28f58a7d1ca8070da2a40e8b2e83635d3042a82eeb4bc3bdfa2605cc6a1f2"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.8/cmake-20.1.8.src.tar.xz"
    sha256 "3319203cfd1172bbac50f06fa68e318af84dcb5d65353310c0586354069d6634"

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
