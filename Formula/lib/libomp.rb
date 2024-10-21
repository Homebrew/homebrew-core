class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/openmp-19.1.2.src.tar.xz"
  sha256 "40bff38f7ad008ae67a8c3739b9dc4b789b159281dcc1a8413be916b23de7fa6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "520137cc5bcfc04b30d94eb9ae68bde4d735a49a88c08c6f905c4a9e55f191a8"
    sha256 cellar: :any,                 arm64_sonoma:  "88a3de0a0f4f25314b668d2608ec05fdb5d73061b04fae4111e5c26d90e6aec6"
    sha256 cellar: :any,                 arm64_ventura: "357f19d79836752f7f51c7f9d8781a9605b84cd8348b9a6535be9452f7a12feb"
    sha256 cellar: :any,                 sonoma:        "c1f47cf97211fa4f7f5702a15e2075a5214d0d64955c4896d1e9f7d5e5835224"
    sha256 cellar: :any,                 ventura:       "fd482b76fd54a0afbc0b719e5e72e44b2b0b73a40ae97e3235b56969007d370b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0bc9ee11207aa9a68cf23ad088a6158376dd9a43caade28bb573fa8cd852185"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/cmake-19.1.2.src.tar.xz"
    sha256 "139209d798fbe4a84becfa605aee7fd8f4412c6591976f3e672211e3fbdcf65b"
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
