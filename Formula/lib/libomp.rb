class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.6/openmp-21.1.6.src.tar.xz"
  sha256 "47ce66334725d3919cbdc9a506245ba12c77e1c15d1347c1f7917289624eb7db"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d8b7745493bdf17efebe2927551ec2b3fe813dce97f1ff0f3f8aa6dc16e0dcf"
    sha256 cellar: :any,                 arm64_sequoia: "d99017c08056863871197e62dee6e4ca5aaa10a78ea7be2eeb1e1b54cdf3714a"
    sha256 cellar: :any,                 arm64_sonoma:  "6e6d77037e9a44a386056cfd38c6b7498022ab9de46ade3b6f662f20bb986816"
    sha256 cellar: :any,                 sonoma:        "0bcb758d679b300c47c751b9f9d173067fab430d9365500206d7e8ed7553f0e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73047f9cad1833ea9b2c03aced1f145fa4451493d5c204ed567fc0c79fc9c5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba47354323dfd1c28c153a52900f33464c54556c474d3595f8751ff8f7678091"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.14"
  end

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.6/cmake-21.1.6.src.tar.xz"
    sha256 "e364f135fa14c343d70cac96f577f44e8e20bf026682f647f8c3c5687a0bebd1"

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
