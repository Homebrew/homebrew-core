class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.7.tar.gz"
  sha256 "fc2b617ec8dbe907bb10853ea47c46f7acd8817bc4012748623d911aca43afbb"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b7fbc5284b7a792bbd623653bef33cbcc28a58dc4d6f9d77ba952632bd5fad09"
    sha256 cellar: :any,                 arm64_big_sur:  "c3735b9858047c19d5036d1605131c5c908331b07368d71e001319cb6eb0251d"
    sha256 cellar: :any,                 monterey:       "3293c226155ff048bc6a95bfbb686b820813c2c89d19d3eba94b8a566b9e4b89"
    sha256 cellar: :any,                 big_sur:        "b02e036c6fdfec2727e7d36b1613d28f8e0b8c117d9de16106c456cfd8705e7d"
    sha256 cellar: :any,                 catalina:       "e8510fde949edcae703f80268d165fc90e5aa63dc3a796314fc83747b2b5b1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4835771a6bdac3891a46775bdd16d6435107131d1037b7319a7211d37f94ae6d"
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
