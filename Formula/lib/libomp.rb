class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.5/openmp-21.1.5.src.tar.xz"
  sha256 "4bbfe240f23f873fe5fdd4d65e07b6ec0c0a4721cd0d339018b1f520cee48a08"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38048b31f2576bd129393ea2552a83378654b5493e589c3055be5e0e53f60d16"
    sha256 cellar: :any,                 arm64_sequoia: "58b99f5cf315417edfb10cac00e49bcc6881ae56af2d239ea6e6d7f7386bf549"
    sha256 cellar: :any,                 arm64_sonoma:  "1dc6c2ebe7a9c7735f634cf52560dd1f78137fb4ce7ac2a2e041a8d3d490a4bc"
    sha256 cellar: :any,                 sonoma:        "91c75d8998864a39f4bb494a29f1b5e2e93feb2e6f93a52dfb25ded932481fad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "805b9757d63c847d6d0a979d432ca89dd5cb8349365b16def7da4bf315de66de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20716e60d140026a8bdfb40972ba5faf7a831fdf153c00972c5f6e382d86e2cb"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.14"
  end

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.5/cmake-21.1.5.src.tar.xz"
    sha256 "48013d5714a96419bf993a2e5e4c5827377e8cf9c565070731fb2305d50d9511"

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
