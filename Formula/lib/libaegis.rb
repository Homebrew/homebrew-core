class Libaegis < Formula
  desc "Portable C implementations of the AEGIS family of encryption algorithms"
  homepage "https://github.com/aegis-aead/libaegis"
  url "https://github.com/aegis-aead/libaegis/archive/refs/tags/0.10.5.tar.gz"
  sha256 "9a162cf4a37a10a5f7c1a2034c391f3c3998d28ad3ed9f823f0b3d24971abfe4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9fc5a0c89e5771f308e2183cd9ca86d62f4182c7ff8c650331c9723e99bd0d50"
    sha256 cellar: :any, arm64_tahoe:       "548d09f069ea11cb837425b78aeee246ebd9faa065d7f34098233b85edd220bb"
    sha256 cellar: :any, arm64_sequoia:     "94b157b1e8455c1fc905675699e9eeb94fd266027388523b477cb9809b20c3e8"
    sha256 cellar: :any, arm64_linux:       "6fd263dfd8d05f655eff152ae06c7ae78b4749dbfec813570c423c65fa18c1f5"
    sha256 cellar: :any, x86_64_linux:      "6c6f0dc21303d85856f4c13a0fc60f941e13eb5cfec7457c1d4da6a4ad5ff5f6"
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
