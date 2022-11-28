class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.7.2.tar.gz"
  sha256 "49018ee24b1b13c166510354c03c2f1489262b10ee09b12cdeaec5745f99ac50"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "06751e5f9f731c1666b492ba0315c1e114fa46c956bd49d385cfc946d1c133ac"
    sha256 cellar: :any,                 arm64_monterey: "2abf234ae50a74b3211a04e375e2161e8a44ca9270edede30e46b421a4920936"
    sha256 cellar: :any,                 arm64_big_sur:  "c5b1f108d4ca00febbb2960217184038810ce780726256ecdce07244897599bf"
    sha256 cellar: :any,                 ventura:        "9c039066a3d24fd2e6306a9ebc40dc98a793f790a28928ad2d70884d779424fd"
    sha256 cellar: :any,                 monterey:       "f70e2551405e647af6cd026c6754a9d1705ecb0779695a185f3055f6982c9b83"
    sha256 cellar: :any,                 big_sur:        "1259c142da276f9be4f33bd2e6c2fe2412216c23f421488de15ebf3e4d5ac98d"
    sha256 cellar: :any,                 catalina:       "d1e2b34ad1a2db81e53e288083e3271f9146a21006573fb888ad314eb17a3dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a79cd43630730bc92c55f62740447314f459c90d386761beb252092f3caeb314"
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
