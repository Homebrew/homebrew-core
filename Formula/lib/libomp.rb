class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.1/openmp-18.1.1.src.tar.xz"
  sha256 "8a2ca2d7bcc42165f6dd6029ea3632ccc5637fc5a5fe6707a0ca2293655f90ed"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "88779ca947ef1e5831f4c3ad727c6d7aafaa7836ef56c2aa1ca4d90acdd953ae"
    sha256 cellar: :any,                 arm64_ventura:  "50b9818a66bee963ed2f31ac3890b845c16432c4f6c145503e2317c70f31fedb"
    sha256 cellar: :any,                 arm64_monterey: "204dc957e9cb07ddea9847f363502b068337fb7dbae51a06d56f0eda390007b8"
    sha256 cellar: :any,                 sonoma:         "bc165d29fa345c06317746f672054f3c0ffa2bc399b4415036cdc2320a88339f"
    sha256 cellar: :any,                 ventura:        "e12a6db86b95e962aa10e3b153464900d4e857c6350b6ad94c9c7739b4019556"
    sha256 cellar: :any,                 monterey:       "5b63f5fc85a38487ad943dcd9807a1c7b2d4abfb9cf35478b0f5d3231aa292ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b6f5ee7ae0112fa5827de6f1ba7f0151fb638d13fd6017fa66dc013cc6cd4a4"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.12"
  end

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.1/cmake-18.1.1.src.tar.xz"
    sha256 "5308023d1c1e9feb264c14f58db35c53061123300a7eb940364f46d574c8b2d6"
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
