class Libaegis < Formula
  desc "Portable C implementations of the AEGIS family of encryption algorithms"
  homepage "https://github.com/aegis-aead/libaegis"
  url "https://github.com/aegis-aead/libaegis/archive/refs/tags/0.9.1.tar.gz"
  sha256 "9dcda145c57542f63d28921ba8754e0ede9e782f1dac48de4db0151175fe3099"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "960c1aa2f45bc307521bc1434647c73b9c3e089d0246f2f2a5e237fad4f7b23c"
    sha256 cellar: :any,                 arm64_sequoia: "bcdd097645b631e3955794978550920ed1e1c97ae3682c820da55f4dc7cde533"
    sha256 cellar: :any,                 arm64_sonoma:  "0b0fab071a81b639fcd1b894a7470ab06122de773c0a0dd8b7ee6ab354a49572"
    sha256 cellar: :any,                 sonoma:        "78c929858c9e8964a8e5a64a12fa42e51512d6d21bd071d00d9a65702264945d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7fdaa1455da818e47413034bb16970b9cf3559a679e0868b95623d97e1b0363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b17d36c21070888ba219d5c82d9c178366c92217e16602e214b59655fc8d4451"
  end

  depends_on "cmake" => :build

  on_arm do
    on_linux do
      depends_on "llvm" => :build
    end

    fails_with :gcc do
      version "12"
      cause "error: inlining failed in call to 'always_inline' 'veor3q_u8'"
    end
  end

  def install
    ENV.llvm_clang if OS.linux? && Hardware::CPU.arm?

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
