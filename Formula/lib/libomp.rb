class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/openmp-19.1.7.src.tar.xz"
  sha256 "bd7e6901ab086fd268750363017935fd4a717c153dad3c2aab86cb0140d9e3fe"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f80484105bce3f6c79faaf24ad3d6a9146bc5def386cbd5b150780036a54de3b"
    sha256 cellar: :any,                 arm64_sonoma:  "df8bbd27e18c5206c5ca1b2d8858308f0a41c1c9f7a73f5d9593e606d37817e3"
    sha256 cellar: :any,                 arm64_ventura: "395ae313d817c98538718487ce1ced2a85a6b877b620c21225a11cbd14206032"
    sha256 cellar: :any,                 sonoma:        "e24f0307c374686c5b9ced59851f7f25f435910ba8ead7215646fdad9364597e"
    sha256 cellar: :any,                 ventura:       "a0dab0439d02f1fab4dd6a5e90ef9a3b83bea92b4bcc6bb7aac3a9512258d60e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b291aaba3ea2b62327561fa5f5efbf89c3576edcccf9cc27462d755ee11f22be"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/cmake-19.1.7.src.tar.xz"
    sha256 "11c5a28f90053b0c43d0dec3d0ad579347fc277199c005206b963c19aae514e3"

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
