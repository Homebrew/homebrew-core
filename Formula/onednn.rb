class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.3.2.tar.gz"
  sha256 "8cbade2dd955bc8f281d31a2e89e7ad7b11d73cd8281c30a64b2ff8e3a63f07e"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "24016ef894b97391b8ba2327c092634e0fa6d56e5309a4c5b8abc2ea0e050273"
    sha256 cellar: :any,                 big_sur:       "af0289ce4e3b217a32171692346f35b1989e686b2735fc537f99a66b64c6a0d5"
    sha256 cellar: :any,                 catalina:      "77d28b51805d59a0c1fd1edc5de02c44c01949dd01fc46b1b3d6cbf4926fc416"
    sha256 cellar: :any,                 mojave:        "5601c8dadace159795a6fc788949d73a70d2b0faa08c8178bdba67e923297d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8139db4a2a12236e956bd2b34b86fcf524bba9e213628420c1714c6e8ee370b"
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
      #include <mkldnn.h>
      int main() {
        mkldnn_engine_t engine;
        mkldnn_status_t status = mkldnn_engine_create(&engine, mkldnn_cpu, 0);
        return !(status == mkldnn_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmkldnn", "-o", "test"
    system "./test"
  end
end
