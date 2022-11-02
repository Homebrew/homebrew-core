class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.4/openmp-15.0.4.src.tar.xz"
  sha256 "1b6f92013e7555759127d84264c3e98eab116a3a5138570058d8507e1513f76e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1387ef9782bf62ec3d4e6e4a04757505b38fd8b4b777354b428ec01970049d33"
    sha256 cellar: :any,                 arm64_monterey: "22dd6e89f3e9fc50a5958448cc4d97ddd6704959e824895fec6907c4973720f5"
    sha256 cellar: :any,                 arm64_big_sur:  "1d542abe4221cf0f414aa1e0ab23aaab216b78a54b4f85b2cab908e3f5dfb9e2"
    sha256 cellar: :any,                 monterey:       "dc2e03f72742bcc6a59b74b69ad97e068df7e1eb10201a168ca7fab92ce672a4"
    sha256 cellar: :any,                 big_sur:        "2efa691ecb3c1f2b4ddd53cd39f9b6dd6d18d7a3c15d88351659a5825639d9be"
    sha256 cellar: :any,                 catalina:       "fb68262bff3b1c2fd25d76d8b0c96418fc61c50d0c2e10dbff94ba9b613c5a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "610e788b83d5631a8ad03d3613710662289db6be0cdc1f4406c17643fe89a67f"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.3/cmake-15.0.3.src.tar.xz"
    sha256 "21cf3f52c53dc8b8972122ae35a5c18de09c7df693b48b5cd8553c3e3fed090d"
  end

  def install
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
