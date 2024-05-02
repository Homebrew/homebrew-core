class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.4/openmp-18.1.4.src.tar.xz"
  sha256 "1349e019f1c301c490d67053c271ffeb8dbac2b924f5fbc5965468fc13584a33"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "684a57842e11ace999c6df977c60a8ce83041bdbad5817ef0e9a374bf594cfe8"
    sha256 cellar: :any,                 arm64_ventura:  "e01113408febe4c57606376f2710b0ebe4d7e6495b555ce645d955b3c10defe6"
    sha256 cellar: :any,                 arm64_monterey: "447d82bd1164ac5c47ec8898f404dfd987c8d51538b74662684b6f42f32cdd2f"
    sha256 cellar: :any,                 sonoma:         "04dc5fff74a2fcac6b38581d6a678ab2590d091c8cc95732b3ea005790d65a3d"
    sha256 cellar: :any,                 ventura:        "1aba2c179efdb34db0dc7fc7adfa3442d3b499de6ac4fec47ee5618d736a3aaa"
    sha256 cellar: :any,                 monterey:       "a5037e516e98e9ea30889562788017623f42b1457713632e4e169633f6024b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51de9613c2953e0d22c50323fda4d686c9b34198913fbf13fa84cd420564f20a"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.4/cmake-18.1.4.src.tar.xz"
    sha256 "1acdd829b77f658ba4473757178f9960abcb6ac8d2c700b0772a952b3c9306ba"
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
