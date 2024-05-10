class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.5/openmp-18.1.5.src.tar.xz"
  sha256 "d8a52437e2a714eb1243d7b877dbf0fbeaa7134ad7d65833c29b18d937439329"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "83417700a6f8e3477731758a497944d16261eb298d75f56254adc204d17ebfa6"
    sha256 cellar: :any,                 arm64_ventura:  "2573f0c3bac2a4ea49d812dfbbf2d0f8bdb1b51c1767aa142a8de3f3202aef7e"
    sha256 cellar: :any,                 arm64_monterey: "9bcbb4b226579d6fe8f5343fe7f0a424a5e3380335b3dec3f24641193de3936f"
    sha256 cellar: :any,                 sonoma:         "02944df73a9969ecd80d1e7669b0a17cebadb5416132af1745bb25ca7adee355"
    sha256 cellar: :any,                 ventura:        "a4770489197fb9413b375c05eee4b24ef315b26282baedb9b05dd42e39eb428b"
    sha256 cellar: :any,                 monterey:       "9d9a908a4b50db0fca0e2913f3c327ffcf227a70f08b20642787a78e70171ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda05803cc58fd874c1b74f0ac8686905d21bcb750f87bf9a65bdcb977f634a0"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.5/cmake-18.1.5.src.tar.xz"
    sha256 "dfe1eb2d464168eefdfda72bbaaf1ec9b8314f5a6e68652b49699e7cb618304d"
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
