class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.2/openmp-16.0.2.src.tar.xz"
  sha256 "d685c6cf0ab082acbe4ce63cab336e51a761edf7f2985017d91068070bc274d7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "33dc6b1dc2b3a40d8e0ed2788f5c6a1151bdf60f5a6c78c2c938985b669d0807"
    sha256 cellar: :any,                 arm64_monterey: "67dfe38eb76ff67b7b47ae96715a7773ea1dc56e87d44976003dabf7f8945379"
    sha256 cellar: :any,                 arm64_big_sur:  "a76b195df1dd10025483f17f9d2ded9c3828d3180d9d4c5ae85494a16014fe57"
    sha256 cellar: :any,                 ventura:        "3ae0657079172c5bc573113f27d30a18b21a51c30725e5dd6c11a8dd304ef261"
    sha256 cellar: :any,                 monterey:       "19c00fcac16890b3c1e13f5d7ec5f71f3d83cff8e42598eabed96ce35e5aa445"
    sha256 cellar: :any,                 big_sur:        "5e9fe04b19c1c9d2c3c05f76e15ec97c5739250cb7fd5a051816653d23abe4ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41d48576cb9a21fe2707e4b2f86eb7b0f2b871b38429ea460d8d201a005b4782"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.2/cmake-16.0.2.src.tar.xz"
    sha256 "59c7239ec20c4d0bf3325ed3bb7ec8dad585632b0d9a07f0c2580e1ffe2abb22"
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
