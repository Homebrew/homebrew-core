class Libebur128 < Formula
  desc "Library implementing the EBU R128 loudness standard"
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.2.3.tar.gz"
  sha256 "13776667743cf6e3df36bcf4f8c7ac828859ce02c9988514e3fdddc3efba98f7"

  bottle do
    cellar :any
    sha256 "2573f25bb171730278ac2a690a0cf4dfd5edb80458af501da87bfae640d155d5" => :high_sierra
    sha256 "a037db8310c95fecb9b5ae393997c5365011a8f5c753c1277a08af02d31767f4" => :sierra
    sha256 "1446628a1ca48d17d00406e1687f1c3e3ee4b85d3571abeb2d1f3957135e32eb" => :el_capitan
    sha256 "4b0226c7ab062b262b3aaac750d6e8784474e8c81459ad9b04f15cca206fcea6" => :yosemite
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
