class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.5/llvm-project-22.1.5.src.tar.xz"
  sha256 "7972b87b705a003ce70ab55f9f0fb495d156887cba0eb296d284731139118e2c"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1e8896a92b1497cb8d07b07c5314cdc21930be88de4fc5346628f6cb08dd701"
    sha256 cellar: :any,                 arm64_sequoia: "707b308d20ffedde67dd2af50ef266ad4dba4d077e9485efcd20691ab9c96b2e"
    sha256 cellar: :any,                 arm64_sonoma:  "4e0ebbf910154568d74377bd360d8ac7fb863e9116c33a8610b12e0d5d0c78e2"
    sha256 cellar: :any,                 sonoma:        "d36ae2533bfdfa029b1f78ffa5a70d8005674bf26dd92f9307a62e2289dac029"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d0c1964560314d1cb82217cf6c43f2b1ed567f02bd6ff0ecbca1b29480d4aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5d05a383a6743e395f2645ed20c772940c4f904b29117e12bd3dd7735cc3b06"
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
