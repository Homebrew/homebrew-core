class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.0/openmp-18.1.0.src.tar.xz"
  sha256 "ef1cef885d463e4becf5e132a9175a540c6f4487334c0e86274a374ce7d0a092"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "94d6f69b98a401d7317f521fa15265db79925861e782225fbb395f1b6a3032fb"
    sha256 cellar: :any,                 arm64_ventura:  "62e122169ae2ee08cb622d4387a96b4b79328c3e467abf47c0d4ebceb31d31df"
    sha256 cellar: :any,                 arm64_monterey: "fa9d7d4811a9d34d994fcb6744a777f4e04f1c0dce4bed44d2e6291605e991f7"
    sha256 cellar: :any,                 sonoma:         "c223e676689884a49d850819aeefdffd2113daa5aebdb4df0e7f7a15bb8eaf42"
    sha256 cellar: :any,                 ventura:        "b6194a9c904aad1073d85fcef8ecc3194ef2ad573e4026da1e026abd33bd6897"
    sha256 cellar: :any,                 monterey:       "08b72c832321f74c9786216ae34a9ba55f73e4f554dc234170107a2577dc55cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557b45d59df173b81679467b30839d06fa113439b4a7318cdb5f3b91b7223c1a"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.0/cmake-18.1.0.src.tar.xz"
    sha256 "d367bf77a3707805168b0a7a7657c8571207fcae29c5890312642ee42b76c967"
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
