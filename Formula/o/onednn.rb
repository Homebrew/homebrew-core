class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v3.2.1.tar.gz"
  sha256 "2f76b407ef8893cca71340f88cd800019a1f14f8ac1bbdbb89a84be1370b52e3"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec53d5ea12651ed953092f729cc57a9261a0306b5e2a7a8bf5c794cd19b3354d"
    sha256 cellar: :any,                 arm64_monterey: "a420934bfd06b53f50e8501c7727ced9ecd85882caabbaf38aae1708a5bede9a"
    sha256 cellar: :any,                 arm64_big_sur:  "35063d9d401dfad170021f621647c97ac1ef9e1f0e59ba4d5102711fc1aee3ca"
    sha256 cellar: :any,                 ventura:        "d4359decefdc6ee8b51fff8ab539dd80782c696b1cdd3bbb0f5a28a6cf87ad76"
    sha256 cellar: :any,                 monterey:       "0da7de658ddfbc868ea9989629590c93c17b878497fd4a44a384dc08c73c56e6"
    sha256 cellar: :any,                 big_sur:        "95199b5edecbec0b4116cccf2709ef9babbe78bcaa225ed76a9bdb486ae72384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9c846d99036fa29e0e7b44fdb2914d855e3eed03a33f4e77efe9275e671bdf9"
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
