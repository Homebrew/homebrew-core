class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "275f1eb074a517ee1116266e59e1ef3400e1f4b8b81ad9807dc4504e94002b4d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "42374525f4d1e29ce8730b5dc1e3e23be5ade4ccdc4c722a33f2e40374d340ef"
    sha256 cellar: :any,                 arm64_ventura:  "f102edc514da32e070fd69b00d67d67b3687a21d422d7cc531c3acaf69ab329e"
    sha256 cellar: :any,                 arm64_monterey: "32fe987aa6c114bd8774fcf5c42622a7de8cb5fee39fbb21c83918fe141bdc68"
    sha256 cellar: :any,                 sonoma:         "d97b57e23988503d9dd92526394750cd40a060793f8d2bac3f1437b7f18e7cff"
    sha256 cellar: :any,                 ventura:        "bbc1af91df4df834d2fa54805e9efcc95b26b477c62d9614fd006583cacdab7b"
    sha256 cellar: :any,                 monterey:       "63157e3499bde3b44edca7a31757bc0f0cdc8d0643d39dd0fdb26e383cec16cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b03f1dc4b55109c1025580b1f82457eb07c932160fd02f528d127dc9200b6a"
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
