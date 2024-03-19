class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "275f1eb074a517ee1116266e59e1ef3400e1f4b8b81ad9807dc4504e94002b4d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f38c7cdc52f89909ef7da32093842e43276a83bd220105568b6a27d747cf278"
    sha256 cellar: :any,                 arm64_ventura:  "2f07a947944fbbdeee23b7536ab24d2ed1bea39dbeaebd96227a9407ce882ad4"
    sha256 cellar: :any,                 arm64_monterey: "6c564022659fcf51ee2e3f9fe8fb85500d68e82153a7778963a8a31db20a99c7"
    sha256 cellar: :any,                 sonoma:         "5c0365a26e8588c871d55373ed64f6b9c6050383793a9d8d811ad50bbf5437d2"
    sha256 cellar: :any,                 ventura:        "994a572f0080f27769670f73a0e7af2c91cbfa5b305bec2febada106619b054a"
    sha256 cellar: :any,                 monterey:       "afb763e25b6779bbee1aa5532e9de64779cbb04f8aacfbea3a24dc6f2354950d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c519d1c06ba8aad9430df0cd4f7c78e72d2676efe16572c115a8d8f0d7affd"
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
