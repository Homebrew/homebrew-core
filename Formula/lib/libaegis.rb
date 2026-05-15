class Libaegis < Formula
  desc "Portable C implementations of the AEGIS family of encryption algorithms"
  homepage "https://github.com/aegis-aead/libaegis"
  url "https://github.com/aegis-aead/libaegis/archive/refs/tags/0.10.1.tar.gz"
  sha256 "0f3350dabf1d54ddb94a34a8fc8509ba21cb8431a841a98be78ec274238a86fc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21cc2428570e656c2251478d4c04be8a9fd2322927f022a37d2b001f56fa05c8"
    sha256 cellar: :any,                 arm64_sequoia: "683b9f5c7e1a6c53103d1a684071b12f346adb89a26c33c5ee5973acb7e1f931"
    sha256 cellar: :any,                 arm64_sonoma:  "bf72aec5302129e7611e834c76775e765367a0d7b29cd333b73f7b2e125dc380"
    sha256 cellar: :any,                 sonoma:        "80d1d09122b433ad4743f5db81152e8c353598c978433f5bfb2e4daf006fd3f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "224df5254d16376f022ba76dc3027f3ca687e5a8f2f26c8c12b0823b8f99f565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d90673a5ccff080cf7f36daa9cdf4231df0e11525a7e4a67e09f602f589d6a4a"
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
