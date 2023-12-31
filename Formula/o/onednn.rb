class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "24e726989785c5873d45ccb8ab698b22b53798c773e96f4226f2aa622694ea40"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9c090ef4cd1e7777f4602bb116ffd30d90b427a9340ccdfe9ace7fbfde180c12"
    sha256 cellar: :any,                 arm64_ventura:  "f49c494289b1b75928dd91b7416c1f223cec22af085545a59922e2dfc45b057d"
    sha256 cellar: :any,                 arm64_monterey: "4d755932516c137aaa763ffe682c0283811968db4a0409516ec50b0fd414c6d5"
    sha256 cellar: :any,                 sonoma:         "59856e890cb92bf2cc2d7a5200eac0f70b9f24defec8368c02bfc3790b0b1ec2"
    sha256 cellar: :any,                 ventura:        "6b61b8ba2426ece163579a29003733be463893710a68180edf403e6d9363ab8d"
    sha256 cellar: :any,                 monterey:       "5b8b7db099cca077209999c60eacaf81a12f377c34edafeec263567689d66c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ba56fe8f49de21bf8a6049b03d404f4a3ac4e946dcfd0e2af6b48a276f68657"
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
