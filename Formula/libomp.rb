class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/openmp-11.0.1.src.tar.xz"
  sha256 "4d15a21b90e7de2f01296503f6e4b16c50197fbe9c82e7e81f9c07e28bd82ca7"
  license "MIT"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+.\d+.\d+)/i)
  end

  bottle do
    cellar :any
    sha256 "e33301d4141f0cff471442679b1ec2e858288f9e280b867d02c185f5cc69a12a" => :big_sur
    sha256 "ecd6b26d43f875348d755e35e48108e85a2a5263e1a2e9d59c71c4a2acc926b5" => :arm64_big_sur
    sha256 "a882de3c79dd02d1fd9c622fb8e667d97e7aa0319f2600ec5ad06e5e843a66c6" => :catalina
    sha256 "0716db5d51938b2fae8ab89c71db9a5786849b84c3924e215916f889f7e9e4c1" => :mojave
    sha256 "421af56c2bd2980ac04213b9e772ec9593e23737c2816cfca829f22db388cb58" => :high_sierra
  end

  depends_on "cmake" => :build

  # Upstream patch for ARM, accepted, remove in next version
  # https://reviews.llvm.org/D91002
  # https://bugs.llvm.org/show_bug.cgi?id=47609
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/7e2ee1d7/libomp/arm.patch"
    sha256 "6de9071e41a166b74d29fe527211831d2f8e9cb031ad17929dece044f2edd801"
  end

  def install
    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    system "cmake", ".", *std_cmake_args, "-DLIBOMP_INSTALL_ALIASES=OFF"
    system "make", "install"
    system "cmake", ".", "-DLIBOMP_ENABLE_SHARED=OFF", *std_cmake_args,
                         "-DLIBOMP_INSTALL_ALIASES=OFF"
    system "make", "install"
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
    system ENV.cxx, "-Werror", "-Xpreprocessor", "-fopenmp", "test.cpp",
                    "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end
