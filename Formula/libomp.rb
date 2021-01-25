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
    sha256 "4988dc1428616d4d116cd20ce97b4c0dc465d030c788d5eeb8161b10786b87cb" => :big_sur
    sha256 "e4bfe9b5a62d5f1a3d09e9ae242e945eabf0905abda6e85f7ba623fd2a4faa70" => :arm64_big_sur
    sha256 "36322824081323ee666385e1ad0243542a8c511c9a61d6d4d158bbb153e2ef91" => :catalina
    sha256 "7313b982b9edd1f1f52c6434f0cc37c5946fd66e758a43c9f02941b08632cd66" => :mojave
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
