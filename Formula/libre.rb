class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "efc387c9f06cac3f0a70e14a8da9d986cb15580e4712a496df66f3fb0257ac9b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1ade28294f554fee36b7a259fb0162940668f7aa55e43970d92b0764d93cb59f"
    sha256 cellar: :any,                 arm64_monterey: "7fb0b56bf34aed0b0af9d88918bd1bd7a26b7d3175b0932b1b522ab589e5f209"
    sha256 cellar: :any,                 arm64_big_sur:  "bcecd8d611e50023e2c7630d6d8916f76e56c6c07ea139f4141966938f8a5a72"
    sha256 cellar: :any,                 ventura:        "7f310b3ab960e6a6d8946b49da5743408dd3a7167d42d7a10f0a2f4cd60b2b45"
    sha256 cellar: :any,                 monterey:       "4f5e1a97fef88754b8d83c9d36a361e078d75735bd9dc318287b2b94e93c9e2b"
    sha256 cellar: :any,                 big_sur:        "5e671462ccf21d9cc0113f53fa6f9e3317b4fd9f6ca08fe7d5cc72694a1a2677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "580447c712ec119be456f2bd8ccc6c7d63bb4da8a4693f3ac2976a2873fc88f2"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
