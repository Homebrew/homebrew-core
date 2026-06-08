class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "34a6061bbfbcc70f9af7e9732fd5588e4b1288a9d04ce1369c49dece46502e38"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16d4d005c638f6cbb34f4481c8e4d952fe868e6633465d915265cca126a481be"
    sha256 cellar: :any,                 arm64_sequoia: "71953001f6328485ee71e6ae9fd0ff2da5307cff2392d7e477854e08e08ecd2c"
    sha256 cellar: :any,                 arm64_sonoma:  "55a88b72ae863c98a292da62c2ed2ed6458047b3f5f8ed2bc348fd7afb1c2b7a"
    sha256 cellar: :any,                 sonoma:        "cd2dd2c9a91e7a974818ba0ab5e59d05b0beca3a326bdd32b6c3e0c987672684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc15c0506ad2a6a909acfcb00a859f880312d7af20700845bf7ec778609e9959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee605805e7a8bc175adcb3015ce521c371f2a6023d75dc0fbf4669e3c2e269a9"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{include}/re", "-L#{lib}", "-lre"
    system "./test"
  end
end
