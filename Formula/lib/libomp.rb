class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.1/openmp-17.0.1.src.tar.xz"
  sha256 "d4a25c04d1bc035990a85f172bfe29a38f21ff87448f7fbae165fa780cb95717"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0b49f04d30dafe89e3e986986dbd5c8c2939e50eeee76b38516ff7ca03fc6f14"
    sha256 cellar: :any,                 arm64_ventura:  "3837963331024d9dac0d767143319e0fd8969da62e034337c252df18204b990d"
    sha256 cellar: :any,                 arm64_monterey: "5ae86654170bbc1f799bf25e72fd55fb00c99ebbde1d6676df832d3886b0f1fa"
    sha256 cellar: :any,                 arm64_big_sur:  "06ce8da414325ee89fce6de57622da8c150b58d4b392edf711184123053962d9"
    sha256 cellar: :any,                 sonoma:         "aa4303595c1a81cf7008ec7930b915a95140710a808ca4cb08bba69c8c7ff158"
    sha256 cellar: :any,                 ventura:        "5e794b1f3d68a9e2b721c6a1875892968cb0da74e7097dde07a89d6908200397"
    sha256 cellar: :any,                 monterey:       "5e02c68a28a98c1c34b3436061484458ae49c4f21ec7fb6ffa0b9d9d43e6e454"
    sha256 cellar: :any,                 big_sur:        "b969a154c0c132501a82a9dcd64952a179c5a9a424cf3a1f93419920e8a83be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f91eff0d82d9b644de0e7be6dba7e8c691ef31b2047ee049ff08b30a77a8223"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.11"
  end

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.1/cmake-17.0.1.src.tar.xz"
    sha256 "46e745d9bdcd2e18719a47b080e65fd476e1f6c4bbaa5947e4dee057458b78bc"
  end

  def install
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
    assert_equal version, resource("cmake").version, "`cmake` resource needs updating!"
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
