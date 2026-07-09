class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.12.2.tar.gz"
  sha256 "d16dc7ceb69d5856f3974cab4384f3076f9732f70313b581a351a3a8eef8a642"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "928ea89489be3780587c0b05cb35b42ca3553c1861b535fb45a82335972faba4"
    sha256 cellar: :any, arm64_sequoia: "e8d584b9edb82db1f039c6fe6ab65d4ab177c7d2b29768b59604f881a7aefc10"
    sha256 cellar: :any, arm64_sonoma:  "ad5b75889cb14e87f33b7814a0392f7de58170e9d162043676c28a7697764487"
    sha256 cellar: :any, sonoma:        "a14034818e968b1a598129c35a32eb1f2461f555da5b21cbdec945cbc8245f74"
    sha256 cellar: :any, arm64_linux:   "c3ab3d86419534849bf31d33d8aae151799a6fc87431b9168efe999abf20ebb6"
    sha256 cellar: :any, x86_64_linux:  "ede752b08fae87dd0619737e7b20c1a4b258fe5c31f078ac16ae4bf06808bbf1"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <oneapi/dnnl/dnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system "./test"
  end
end
