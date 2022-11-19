class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.5/openmp-15.0.5.src.tar.xz"
  sha256 "fd1f4ca2d1b78c1b42bd74c9ae32b3bedd77242e8fb5dc774ace4a43726d1615"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "43ee232a19468d495109a73e581fea68f7d49fda907b83e44e4f0ab5b8c0d341"
    sha256 cellar: :any,                 arm64_monterey: "4e150f9429aedb6ee9530cc8091314e67a910c6a4a6e95dc3f90a2fbf0b86b2b"
    sha256 cellar: :any,                 arm64_big_sur:  "600e0716d812c318b8ce06c5b9b28cd774e315d60d84ccc04bb0af1721d4bded"
    sha256 cellar: :any,                 ventura:        "9f75e527421f21e3330cb45d00e50c3b2c71c12a131522d45f9ef852af2c43ba"
    sha256 cellar: :any,                 monterey:       "ff127958fb43bad1f71ff0c7727cbf18ecd0e5ba6d1d1a70bedf142c6cde5b0e"
    sha256 cellar: :any,                 big_sur:        "eff078fb1c81ce234f9a2c9fc9d67a2ee82b36fa50a823a7319207cf71d51a25"
    sha256 cellar: :any,                 catalina:       "b854a6c8a9e58f362565364104ef53e40ccde0150c30d6d6b137420e8c930182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f957ccf59df651b535bd8f6d05f41de542817fa4a739b7a76bcbc8ee5266ed5e"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.5/cmake-15.0.5.src.tar.xz"
    sha256 "61a9757f2fb7dd4c992522732531eb58b2bb031a2ca68848ff1cfda1fc07b7b3"
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
