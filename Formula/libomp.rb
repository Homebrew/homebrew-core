class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.2/openmp-15.0.2.src.tar.xz"
  sha256 "2567c5ed2b2d3343a0f3b2d5a4dd116a37776d60c880aa2b0c3313a7f68ba4d8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa7bf1af9c803b3333a7dcca19f405a368dd131d0bc018c8ae28120dd8bd9b08"
    sha256 cellar: :any,                 arm64_big_sur:  "3dd1e9029a3bc6f296a37efd52f6b1d098e401b3a9b3226c6ad9911e6cbaac52"
    sha256 cellar: :any,                 monterey:       "187332d52fa370c84117a2733b51c57171fa572818d62a56d7e816e933e812f6"
    sha256 cellar: :any,                 big_sur:        "a4e0796616d09221e2a486c95f9aa7c12d3c617e594b1d463a8f479bd4fa45c2"
    sha256 cellar: :any,                 catalina:       "ea656ee0de7551163c419921fc736f21252b38e8e91676b8314dfe427d45831a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97da096230c807be7ca8a5647b7bb29b60b768d2e10e9c307f216659d07b0b09"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.2/cmake-15.0.2.src.tar.xz"
    sha256 "c47c4d54bb311298abe97e7d8e8185eaa8d71feb6d85e5e38356a70679e5c61e"
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
