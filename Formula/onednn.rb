class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.6.tar.gz"
  sha256 "9695640f55acd833ddcef4776af15e03446c4655f9296e5074b1b178dd7a4fb2"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9672c35e99cbdae7e5df778cbe49bd984fc94cc5916d07bff04105e08f33c23f"
    sha256 cellar: :any,                 arm64_big_sur:  "5de335a07c74904d16dc8e85b293a4da3c977b490ca2fe158b1d2882ad46c8f1"
    sha256 cellar: :any,                 monterey:       "8a4e3e1a0d75a117652ed071b33c7213749d82099e0b31d03cb2c5153d4a33d5"
    sha256 cellar: :any,                 big_sur:        "fb659ae283897c68f839e0c99194b6f353ff4e000bfb9f8805dc6b1c2b91d885"
    sha256 cellar: :any,                 catalina:       "8081692c9939f440bcda139731efebee95072e7ef6ca81c2992a6a6ea154f74c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5ea66b8325cdc71da8664b875d78d290348cc19633e8c347af959b6fda23119"
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
