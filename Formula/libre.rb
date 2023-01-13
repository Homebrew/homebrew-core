class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "2e3c0c8d1eb4879bfa8ec3329d3bab1d9b24a724d8e1a3cce57c4db58664f03d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a9218f027939230dc6a96b60c1da5e181f74e8448a1de9607d2d5c8299d575ec"
    sha256 cellar: :any,                 arm64_monterey: "f96441b76c6b70386052e716bc6eec33a534a92d0a40d497202227d45f8c20bf"
    sha256 cellar: :any,                 arm64_big_sur:  "d2b2c4906cc7e07142fe66581a7caeceb4a59e93b40fb71411cd63db1a58f0e4"
    sha256 cellar: :any,                 ventura:        "a94b9e9b5f09d68d28f49dd72c19eb02ade4049c167503dcde2bf2271c4abc19"
    sha256 cellar: :any,                 monterey:       "c9928b853d35ed845862eb773fdaea5ff3d2e14c362311305e803c23de8de6bc"
    sha256 cellar: :any,                 big_sur:        "462a04fdeae649ad14f6969a0de7d3556f468d2b67f1c4140022fed42e3a91f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f190ea625b7ffc48b5a0c9235bb663a68990d15e9ca6fb5392babf44ac88e907"
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
