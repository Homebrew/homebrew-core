class Libaegis < Formula
  desc "Portable C implementations of the AEGIS family of encryption algorithms"
  homepage "https://github.com/aegis-aead/libaegis"
  url "https://github.com/aegis-aead/libaegis/archive/refs/tags/0.9.0.tar.gz"
  sha256 "8f439ec9ae9913280617e5e34a1d7e2087993e7d519b027e3ca3ef1f09323603"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14d1a287799cfb3eff4e723f28bbd2f4cd3cd08a130ff8c829f3a4edf66668ac"
    sha256 cellar: :any,                 arm64_sequoia: "473c934c390c81d8385e5137f8f36e5e4b5311b6f29605f1215c6964113cc570"
    sha256 cellar: :any,                 arm64_sonoma:  "c5a596190cea65c218afc12711c493179eea9ae8eaefef37d2abf7050d841f56"
    sha256 cellar: :any,                 sonoma:        "b886a3be132a8515bde749ccf53a9fdf4bab45c20dc692abf486cc6a29a28fd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8432a8a67410b11357ac579b4536deb6e65a823fefc4689fd495411777d17d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b83428cee584d7251d8e64308ed1b5f671e63893fd588ad1fed7e586400c38"
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
