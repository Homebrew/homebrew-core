class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.4/llvm-project-22.1.4.src.tar.xz"
  sha256 "3e68c90dda630c27d41d201e37b8bbf5222e39b273dec5ca880709c69e0a07d4"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bee4135b6f3850931d516b29a0ca7ba41520c61aba6d51be3efaf2ff68d8db56"
    sha256 cellar: :any,                 arm64_sequoia: "3d9b92e9d440447929bc2bf11016055ede00c3ffb23cf59d322054e00197f7e5"
    sha256 cellar: :any,                 arm64_sonoma:  "ae86e526f5561e8636b5f8ea15a91fd94dd2a3076133ca93df764a8893c51462"
    sha256 cellar: :any,                 sonoma:        "8681247eee42bb401919c7ef2dcd569f8f51060b453a39614767ea7f769f9f7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6ff0af986deec7dad2ac75b033fb9d7fa6264642430fbd25f663616396e8aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8937e50d475338318d2a3bb6f0d31cf5ba6dc223fb05687968cff02e3e10ce2"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.14"
  end

  def install
    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    args = %w[
      -DLIBOMP_INSTALL_ALIASES=OFF
      -DLLVM_ENABLE_RUNTIMES=openmp
      -DOPENMP_ENABLE_OMPT_TOOLS=OFF
    ]
    args << "-DOPENMP_ENABLE_LIBOMPTARGET=OFF" if OS.linux?

    system "cmake", "-S", "runtimes", "-B", "build/shared", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "runtimes", "-B", "build/static",
                    "-DLIBOMP_ENABLE_SHARED=OFF",
                    *args, *std_cmake_args
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
