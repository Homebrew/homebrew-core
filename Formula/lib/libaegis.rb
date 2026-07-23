class Libaegis < Formula
  desc "Portable C implementations of the AEGIS family of encryption algorithms"
  homepage "https://github.com/aegis-aead/libaegis"
  url "https://github.com/aegis-aead/libaegis/archive/refs/tags/0.10.3.tar.gz"
  sha256 "2f2682c1d08d9a5510caca1c82e3f8ea91f7085fef2ecbed0c398b2a921c79b1"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9072fddecb6b077000edf40a561759d3aa53377f0e4ca0784044302740c4e299"
    sha256 cellar: :any, arm64_sequoia: "ec09589bd139feb28aafa06ddfc3b9d966c472d79c7932926c7a3d957e0ad6a2"
    sha256 cellar: :any, arm64_sonoma:  "82095481991eaa985c7a6f3fb2e368bd7fe942731e0fa5fa9e96877c2f84ae57"
    sha256 cellar: :any, sonoma:        "79ef35267e08bb4e1a716371da5bb35701bb1c586e00820f75a88eaa74847a8d"
    sha256 cellar: :any, arm64_linux:   "167e84042e9fee90f3c6ddc23211724f35f839a506cd62c715af3d639958bb86"
    sha256 cellar: :any, x86_64_linux:  "74ccde5fcd7cdb3bf5ea1f06b79398fc0633935e8e3365e78402280091e41038"
  end

  depends_on "cmake" => :build

  def install
    # The library contains multiple implementations, from which the most optimal is
    # selected at runtime, see https://github.com/aegis-aead/libaegis/blob/main/src/common/cpu.c
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      #include <aegis.h>

      int main() {
        int result = aegis_init();
        if (result != 0) {
          printf("aegis_init failed with result %d\n", result);
          return 1;
        } else {
          printf("aegis_init succeeded\n");
          return 0;
        }
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laegis", "-o", "test"
    system "./test"
  end
end
