class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.21.1.tar.gz"
  sha256 "2c55baed02f2eec6d0a79ca0ea0892c5a9c91a91f510ec47a316fa16b97c4f41"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "34ea7a99b940335da267470b255127a83a9b1aa4b3320fead6485aee26bd0609"
    sha256 cellar: :any,                 arm64_sonoma:  "16205615cd1dc478127d4c2c491bc60004aee9921598049aa0e0fcf91a8b4287"
    sha256 cellar: :any,                 arm64_ventura: "11ea71c3bc2c4714f642956a0eae68394e808e673a58b19d6c48b68e1290421e"
    sha256 cellar: :any,                 sonoma:        "4f33241449107f5db4fbebf63ad5d803d7a6cb73c0082b4ce8c8ee605005078a"
    sha256 cellar: :any,                 ventura:       "156ca82d2bcb8cf9dda9448fefc6349be8bd9e6e9bba103de8e8505aa84a34e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c3ceddeb2d36e774d651dccbc314e74178bea0768a1e3e822a8180275545418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed9cf53bd7ef114e97aa5d2a284efc72c738fd28664991acb70e54fc381a65aa"
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
