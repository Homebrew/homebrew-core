class Libusrsctp < Formula
  desc "Portable SCTP userland stack"
  homepage "https://github.com/sctplab/usrsctp"
  url "https://github.com/sctplab/usrsctp/archive/0.9.5.0.tar.gz"
  sha256 "260107caf318650a57a8caa593550e39bca6943e93f970c80d6c17e59d62cd92"
  license "BSD-3-Clause"
  head "https://github.com/sctplab/usrsctp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4b589e181e22152697f3bf6f14a84e9e9e7c26244f9e8468a76f6fe918ce113" => :big_sur
    sha256 "bb88856f61f5e9353df491a962ebd40adf7a5989620d437abb5f2a80fc67714e" => :arm64_big_sur
    sha256 "75ca75af9d013e188f37b926ad22fee4d2f54baf9fc1a3ebf7f04796957ed360" => :catalina
    sha256 "fff9829e035d500eaa8b67fc687bfdb15a3b23bc0f6c26148b339c7fd54de0d1" => :mojave
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <unistd.h>
      #include <usrsctp.h>
      int main() {
        usrsctp_init(0, NULL, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lusrsctp", "-o", "test"
    system "./test"
  end
end
