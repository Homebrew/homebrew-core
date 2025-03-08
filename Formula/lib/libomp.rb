class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/openmp-20.1.0.src.tar.xz"
  sha256 "213d234659d90de46617bd49abe1a1fc65a605988e376f00145d246cac040af6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4b30c510acb4d6283a911800019731fadf24fcfa061d33ff041b6cffac82bfeb"
    sha256 cellar: :any,                 arm64_sonoma:  "131ef21fadeb4b6d30e7a991a5ffa534274ef2083ade53516d6056d1cdd27955"
    sha256 cellar: :any,                 arm64_ventura: "1ca155d67458f2f69091436526cb95f3aaee4a5080ac94484998648174635e80"
    sha256 cellar: :any,                 sonoma:        "988e79e9f276dd12bda159f82ea1e962f35e488acd5a5f215941cff5cc101a12"
    sha256 cellar: :any,                 ventura:       "734e87ab9077039d8312a83e7e78651b460664487c33e50aa2364657bfed9d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "595f186c947ea101c59b80e224242fbb3e0ef71508d82f821f1f558f496eca79"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/cmake-20.1.0.src.tar.xz"
    sha256 "9fcd319c6bb87344673f262ef5a6a01262fc9a0a741f3477b7e47e238441268d"

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
