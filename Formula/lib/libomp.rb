class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.1/openmp-19.1.1.src.tar.xz"
  sha256 "db7fde13d44579d1651ab1fc399a8e342798f00e85382bfc2bfd073c7230d201"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "38f3bea5dcea956481633d6e28a28f75736089abe31eeb35bd61f9ae7b489c3a"
    sha256 cellar: :any,                 arm64_sonoma:  "4c22a2b1c4b6e2244d151dfdc76320c2fd8b1e08aa90fcd43bcb37c31610aacb"
    sha256 cellar: :any,                 arm64_ventura: "adc2c12562c9a542c84b883d623248c8f51aa3d7379a31eefa0332393f2522d3"
    sha256 cellar: :any,                 sonoma:        "1d86f9f74c89de5451475a44d947360e0dd72f538bc85674505c717570eacccb"
    sha256 cellar: :any,                 ventura:       "e9e3d5aba72f4698a4ead00dcfc90873ab6cb773e40dbbd4c128fd89fadae8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0199bc53978ff6ff8c04c4c3b3e886056e1931bea13102721593c63ba2eae2b5"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.1/cmake-19.1.1.src.tar.xz"
    sha256 "92a016ecfe46ad7c18db6425a018c2c6ee126b9d0e5513d6fad989fee6648ffa"
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
