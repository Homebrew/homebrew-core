class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.1/llvm-project-22.1.1.src.tar.xz"
  sha256 "9c6f37f6f5f68d38f435d25f770fc48c62d92b2412205767a16dac2c942f0c95"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e7a7b1fe7237895696c610657a184a4c1ba87dd7e8411d18e82075264c40024"
    sha256 cellar: :any,                 arm64_sequoia: "dd3f5731b833e7c205bd918c4fff6716771b1ebfce176d46493f914443d452c5"
    sha256 cellar: :any,                 arm64_sonoma:  "5dda69f7b0baf181a657a2c7588a24e699b5058e5d248728c63deda131e89fc0"
    sha256 cellar: :any,                 sonoma:        "0048c15855555ba76d37871c824faa32b0a7275b5104717aa07fc101ca579e1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23a5ea9ebf213e9ca70c88075f9d2ff6ec7f2e34487d936c9b7929520a9bb613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd8f3373e55c1c45db05ca720581bcb4fbbda7e8ba180910bd6f7dffc20c82cc"
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
