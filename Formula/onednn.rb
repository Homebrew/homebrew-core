class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.5.1.tar.gz"
  sha256 "f1c5a35c2c091e02417d7aa6ede83f863d35cf0ad91a132185952f5cca7b4887"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9cfbe4e08c167d580c628ea818d4b118b0414a2ad1d4513e107ffac7c7606871"
    sha256 cellar: :any,                 arm64_big_sur:  "7d15c9ccaad92bacdf12cb8e0664ce0901396c1614762e56685148c23a3ebdef"
    sha256 cellar: :any,                 monterey:       "ede262dd7bb2a63c4a675fcf501cfb55b895ad197b091cdbf693f0662a4c898b"
    sha256 cellar: :any,                 big_sur:        "181e909e6da750cb7832a7e4c69c84571ebab780723719b3f23744acd9830a63"
    sha256 cellar: :any,                 catalina:       "9647de69758d142241815e08cfba654f92930e9aa031c9549164fa9ff80f7830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826125de1180fe334eaf96db102e76be37fbdc1b1fd19f473e078c7aaf5ef478"
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
