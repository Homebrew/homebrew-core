class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/openmp-14.0.0.src.tar.xz"
  sha256 "28a1cbdd3dfdd331e4ed2dda2b4477fc418e455c883bd0d1d6acc331118e4688"
  license "MIT"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c56a6e4de05ecc20e307afe3a04502bd8245d78118d8d8431ecf321f3ad6bcc4"
    sha256 cellar: :any,                 arm64_big_sur:  "ad8604a13319a9959ce6a4adc769b114a78d7c2cb81e08116e499310d1ba518e"
    sha256 cellar: :any,                 monterey:       "c751c4d5205f057c553ac87e132a8eac004e864140b495ef72cb6ecbdfd627a6"
    sha256 cellar: :any,                 big_sur:        "4a4c9a2eecb72ee98bd8510c98d8e0318e63e1400758399ccb5bc1474d34ba68"
    sha256 cellar: :any,                 catalina:       "ea04abaec05a603b3c76f33be974659a6a4cc58bd5a59fb7a1112ceafe2fe663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7daf56ed8b602f30782e77645f7fa3d4eb473e9f82f3da0baf58f9346c2211a2"
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
