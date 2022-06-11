class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.5/openmp-14.0.5.src.tar.xz"
  sha256 "1f74ede110ce1e2dc02fc163b04c4ce20dd49351407426e53292adbd4af6fdab"
  license "MIT"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "99c9a82a20ce0f76ba8fafefd538ecd23839dc57234b202a7f36d89774003914"
    sha256 cellar: :any,                 arm64_big_sur:  "61791fa8cf7a642ed2cb57939c04fa41fbf47390900f22583f067738dad6637c"
    sha256 cellar: :any,                 monterey:       "82d59517f8101fe83d7fe11822250aa1760d975a80eb4622f9ae7d4a67cf9a78"
    sha256 cellar: :any,                 big_sur:        "baaeb5a704b6d245da5834fb3157f4e2e1f2fc1179bcc8da4ccfc7f9579ae9fd"
    sha256 cellar: :any,                 catalina:       "450836950ce6be5a0fc3412f37d6ba409fcb4ba9ecc32b42b2c70f5a37b88d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a8591023d64f61141ab2f125737dc198ff252b87ee383253148b526194228c"
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
