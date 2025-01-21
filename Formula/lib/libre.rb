class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "07de31a6ce2b3bd98747baae7bc8562db37b9d29073817f9994541eee7f548c2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7c88297882782ba6587c6cf3359dcdf47cb1374abe54bd578ad8499bc9d92f70"
    sha256 cellar: :any,                 arm64_sonoma:  "61859aac3d399a062167c3b19a4dc5b161be7530626a62e4531b87a999e13c6f"
    sha256 cellar: :any,                 arm64_ventura: "c87e6fe931ab1bdeced9c74929519b399698f7298a0c032fb2eae376648c0ffc"
    sha256 cellar: :any,                 sonoma:        "79244cbcea2c9f034be69cece24b779e87ee6fe01796d5c974a514fa0d99bd74"
    sha256 cellar: :any,                 ventura:       "7d670bbf2d356f760b0484db663ec0aadf4c5246eda10ba5aa806a5e1ac89e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7d36c7a5a44f7a25a0f0a3fa829f83d02fc0180b816d4c934ca290533ded2d"
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
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
