class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/openmp-21.1.1.src.tar.xz"
  sha256 "eb10379045844c2d2f1b89a15fd1beaf9cd0de524180c6648e9ea17a0661ece2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9cb33c9a98f8641ee9a93e73599a76f8818da51a4af97c69a0681d4dd58430d7"
    sha256 cellar: :any,                 arm64_sequoia: "5204e2053f959a16ed6edfff053f003087a0b83c987327c3c6232cb1a7798578"
    sha256 cellar: :any,                 arm64_sonoma:  "afb6e5bc3a861eaeef2b99efbff1826445d2632c8057146ecb338e79bdf8d533"
    sha256 cellar: :any,                 arm64_ventura: "9beb2682487c5d6a7539ea3c9edabb37a06e41f145615bb7ce16bf4316ce11c9"
    sha256 cellar: :any,                 sonoma:        "d5f577174311174ad4f980fb7a7e721f029f9c7bec0adc5d917298e9c3eedfbd"
    sha256 cellar: :any,                 ventura:       "c0c00008299a9156df71d4421ae52354944cf686ad2711aeeb8e45ad4f91c444"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "597261ad147b32f06ed8b25e22447c6a47514b04dc8f794405e6c03e344bbeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02160edec57a67db8722e046033aee4f12311dd065dd7452c09da87b5a98b00f"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/cmake-21.1.1.src.tar.xz"
    sha256 "9c0b9064b7d0f2a3004f1d034aadf84d2af4e5dca2135ebf697b0a1eb85ef769"

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
