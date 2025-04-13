class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.2/openmp-20.1.2.src.tar.xz"
  sha256 "cb3abc0378d2beaaad000008b12273854f5f4ff3e1c8bc9f4017945592a52065"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f13318c3701440f35002eb43cfd59b61e74c22bad860d87499bf6ebb0904070"
    sha256 cellar: :any,                 arm64_sonoma:  "033d1a3e05c9b78d84a620e5d706832b60ffd6084786772eb840214c57f17bf6"
    sha256 cellar: :any,                 arm64_ventura: "e9582eb859ffeeb8fd94d52a61e746c182e991a877dc5c6dcd5d960340f46929"
    sha256 cellar: :any,                 sonoma:        "e5f14bf360ceb2414d1e8bd8a7c2a08a3de2ea9f1e57bd5091a1acb975802892"
    sha256 cellar: :any,                 ventura:       "aeb5198d0a539ca48dc4a83d86e9f5981bf9202522021fbdf5a5ed659eac82c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4efcba5f465e43857fc1a94ff75fadc0aa10aaca831da360de3095399f5dfad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a5f7b8de2024b0b9dedfc544a052fc282cac10679c3799f4d0cb0023e54fb55"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.2/cmake-20.1.2.src.tar.xz"
    sha256 "8a48d5ff59a078b7a94395b34f7d5a769f435a3211886e2c8bf83aa2981631bc"

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
