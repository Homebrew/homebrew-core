class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v3.3.tar.gz"
  sha256 "8d150a77025f38bff182aaef4dd643625563b2f311c635f86cf4b769b04d7b48"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f52a43f039ab57bf04f974129e966213d4e536071edf75d8f162675e2a2daf4b"
    sha256 cellar: :any,                 arm64_ventura:  "ada1955d8c195d5b8d652cfada4a07d91fdcb976e57f73938fb1f42ebc554082"
    sha256 cellar: :any,                 arm64_monterey: "65d700e571e317f033c1a84ef4e29e3d355b187358f84715c24149b31ad5fc1e"
    sha256 cellar: :any,                 sonoma:         "d21a8b1fef335368e1daa36360456ca1bc0705cfde92d6ca19b6909133720bed"
    sha256 cellar: :any,                 ventura:        "02ebea8c5b189c6843d25e08cd169927b99b3d4fcd33a0f80c1492de71db1b93"
    sha256 cellar: :any,                 monterey:       "27a311c5818ae3ed52548116e4ebb217581467a9cb4ff51f50d12e125c79559b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04876da2f16180df761473a015875eb2ef03b47af5725a3f4f85e053e32e91c9"
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
