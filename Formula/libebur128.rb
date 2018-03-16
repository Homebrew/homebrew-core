class Libebur128 < Formula
  desc "Library implementing the EBU R128 loudness standard"
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.2.4.tar.gz"
  sha256 "2ee41a3a5ae3891601ae975d5ec2642b997d276ef647cf5c5b363b6127f7add8"

  bottle do
    cellar :any
    sha256 "68c4f6d13808ad4d55d0a0f48384e9872286b6041a06f8c3984ccb96083fcbee" => :high_sierra
    sha256 "d4611c0f7becaf4fbdc34089ddaae18e8017ed6dec859adf4fdadb528f989ae4" => :sierra
    sha256 "3fbb561a893cd7e0858ad25e424e66f70a53023865b33d3519fb1fa62ab35bec" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "speex" => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ebur128.h>
      int main() {
        ebur128_init(5, 44100, EBUR128_MODE_I);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lebur128", "-o", "test"
    system "./test"
  end
end
