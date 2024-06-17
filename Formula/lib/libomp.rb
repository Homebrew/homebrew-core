class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.7/openmp-18.1.7.src.tar.xz"
  sha256 "6523c898d754d466b77b64ddca8fd0185c5aeb7f24260ddb0fae5779eb31cee3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c7d313007a69ef594934a732b09f93109b5071c9ce918048c3fd922c24eccc4"
    sha256 cellar: :any,                 arm64_ventura:  "783c9e9a0e4a44efe2061b5d32671796030def2851177fce57f88238591fa7c6"
    sha256 cellar: :any,                 arm64_monterey: "0ad87bf571356f09edac66f4faaab5db4162151e7d453457a41071225045e302"
    sha256 cellar: :any,                 sonoma:         "0b7b1a00df016c58a3cd456678265ecaf0001221904c7de2771a5fc3a4fbac9c"
    sha256 cellar: :any,                 ventura:        "84a9586dd4bcb38323758f38bc6690c5124b74cba07eecc8e580eebe39956b1b"
    sha256 cellar: :any,                 monterey:       "797b4ab69872a061424d72e74fbec8dfcacce0e92a67e891d49266837fcfeea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "023d6df02df05f287362186dd71f56ca60b01c2b53e16d5def86d18470009dfd"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.7/cmake-18.1.7.src.tar.xz"
    sha256 "f0b67599f51cddcdbe604c35b6de97f2d0a447e18b9c30df300c82bf1ee25bd7"
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
