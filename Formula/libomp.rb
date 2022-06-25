class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/openmp-14.0.6.src.tar.xz"
  sha256 "4f731ff202add030d9d68d4c6daabd91d3aeed9812e6a5b4968815cfdff0eb1f"
  license "MIT"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ea503732fdfff1d7fa55fce465529fc44932ea3f9fe07ebc6baea67781c1e2ee"
    sha256 cellar: :any,                 arm64_big_sur:  "14c39ae9191b9e9911b4478e842143f033e8e8511253304dd5f2547511dc73ad"
    sha256 cellar: :any,                 monterey:       "6256bb9844c07150768fce08514da9938b6509fef76a5731efc74f1b005bef10"
    sha256 cellar: :any,                 big_sur:        "2fdcb0b935b916209ef822c006e5de6983fc64fdd5743aee5a235384afcc5822"
    sha256 cellar: :any,                 catalina:       "0686f741811778142e6620ab15ec6134950c20d35354ec0516713fe6bdf23763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a85fcf71416df982e111c658871ebb2d9fabed74d891e6b7528f26e494d908"
  end

  depends_on "cmake" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    keg_only "provided by LLVM, which is not keg-only on Linux"
  end

  def install
    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    args = ["-DLIBOMP_INSTALL_ALIASES=OFF"]
    args << "-DOPENMP_ENABLE_LIBOMPTARGET=OFF" if OS.linux?

    system "cmake", "-S", "openmp-#{version}.src", "-B", "build/shared", *std_cmake_args, *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "openmp-#{version}.src", "-B", "build/static",
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
                    "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end
