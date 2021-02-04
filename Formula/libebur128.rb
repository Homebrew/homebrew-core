class Libebur128 < Formula
  desc "Library implementing the EBU R128 loudness standard"
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.2.5.tar.gz"
  sha256 "165ea2ed15660dc334acf306169fe9d5ccd2b1371afefc5b80fc958c78045c8b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fe625ca313b4c3a0b721601a0f43fc462e425201416a5c0260f362da2a497d6c"
    sha256 cellar: :any, big_sur:       "1aed37e815f1444c986736110c62edde85e84149774cdb3e7b6bf0733d8f7379"
    sha256 cellar: :any, catalina:      "b17e9a6525ea554b665e6f382a6077eeeb21b944c849f9c931e7cf81487729a6"
    sha256 cellar: :any, mojave:        "f019a2618097ca7169c34756f63cfc0fafabac9d5b3b888d51d7d5dbe8c846e1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "speex"

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
