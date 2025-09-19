class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "96fe5776d14aad6a4801bad8052e2cee8911d8498cac9c455b0f303210449e0a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef315517c0ee615a7ea9c22692591629e749212ab65bfa35b462671ef87ed7f7"
    sha256 cellar: :any,                 arm64_sequoia: "69ca6f0b8dcf8deba9cf289c1e5b16aaa19603085fc91357719d701448851ccc"
    sha256 cellar: :any,                 arm64_sonoma:  "5964d74a35a33a08848767d68ae2b67ae711fac58f2f2810ae74b2d278f3a081"
    sha256 cellar: :any,                 arm64_ventura: "715e2c68c81f0c3599f28fdc722d23af5a95dc01cff566b815c49c5ac1c4cd78"
    sha256 cellar: :any,                 sonoma:        "b9ecceefc6695abdd9f74e65cd60b4de3e5c265fa991633ef0c87a08dffcd9d7"
    sha256 cellar: :any,                 ventura:       "fd2174b9d5a0ebef58e692d69eb3e1355905ea176f1c3ad6fdc667da2fcf9d27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fcf241376eb2080a73be103ec32b4fa4d0ef5a8d0d826f8bb4f06f77f803281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b324e5ba58557a267c742c70aa286b1ddc84bf9ae96b0268311446743f46b524"
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
