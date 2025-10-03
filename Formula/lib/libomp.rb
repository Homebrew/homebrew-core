class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.2/openmp-21.1.2.src.tar.xz"
  sha256 "f60455a1e2e127df18f5f1302f0555eab9aecd37f657904a87b2d601178d4135"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34e886a863685fa36641e14ded72866de93beb286e5ac598b7afc8e905f2e7bd"
    sha256 cellar: :any,                 arm64_sequoia: "dc3a41b135f7ac1c5415766615d60e0fb69d167b4b8140496c917a1928d07fec"
    sha256 cellar: :any,                 arm64_sonoma:  "ccf2740208164292f28e79c90e573c567ce743cb76a2b00ecb447f077784ebc5"
    sha256 cellar: :any,                 sonoma:        "2a56d96c5c34196c86a1af08206079241ed32f1d619c355787beea65c34ecf2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28fe46ba9f4fb3755c0845adced6bfc496e6e20cea1e46eb143bb63d5504fe3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "945f2173d39ad4ea8133cec3ed51a6f6c2471c7fb67379d3cd3a55a10567b41f"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.2/cmake-21.1.2.src.tar.xz"
    sha256 "9ccbaf5ed6bb9e0bcedd827a433fb8f73878b64556bbc1da1e17d88ec0bde0cc"

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
