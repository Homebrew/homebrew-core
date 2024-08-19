class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "64dfbfbcf6fb6db5405fc11af38bc804fa0e9fbd7141bfe0749e96842e52f4f2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d46497f49afb4a46a8b09054386d35561016fe7d0af1cdbaf194eeb76ad97117"
    sha256 cellar: :any,                 arm64_ventura:  "12b0b2591fd2a23fb3bf4b358570c112a23284191981ddc87f878d091206920f"
    sha256 cellar: :any,                 arm64_monterey: "8a2ddfd93ff9715ebaf8d666a88737679495b5260e2fdb2b9b0d84f344f734a3"
    sha256 cellar: :any,                 sonoma:         "1a1973a8223463380bc7beb7c03750b1e33a76851b5685c5dd712916461e1316"
    sha256 cellar: :any,                 ventura:        "84cbb6b9ceb09530d1550225926acd755dca94e952581af25401892b4c81779a"
    sha256 cellar: :any,                 monterey:       "7b25f2f116d3f0c461aab3f74153bdc9cc9eed15334d2d1f02c18b06a5d3a4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc2267465a908777246fc597bbdc789c13f3aa99c18de767b31be82800c7ab87"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
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
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
