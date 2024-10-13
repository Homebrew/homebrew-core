class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "ddbc26c75978c5e864050f699dbefbf5bff9c0b8d2af827845708e1376471f17"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f761e3c1833d6bc77a0eabea1c0cf1c4a8b6dfcfe7a64c1ea26e22bdcfe7ee32"
    sha256 cellar: :any,                 arm64_sonoma:   "8b62f040afa960e4efbe8893f066aecb5898d16f04871747ac44f15054219089"
    sha256 cellar: :any,                 arm64_ventura:  "a5b3155297d8e59ee361c9818420a09171a36d57afb86e2277a4840baee5df3b"
    sha256 cellar: :any,                 arm64_monterey: "3fbd5c8cd2c995d1aba81dab78f643b4104859331e5632838dde943f53222dd2"
    sha256 cellar: :any,                 sonoma:         "454aa728dd13c5984c1abbf8e0ec2050e767982ff0899df89f37bc54038f7db7"
    sha256 cellar: :any,                 ventura:        "87ef1fe3ae6948662daefc2aee0cd1393a17f0d230ab69f2495f258ab106f37a"
    sha256 cellar: :any,                 monterey:       "986af6311eb00492062ed5bef9c85727c6f012ae3200e819c344c2645ac7c00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5069655b504607e07453313f1947520676ad195642f13c021229f521da9b4d7"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <oneapi/dnnl/dnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system "./test"
  end
end
