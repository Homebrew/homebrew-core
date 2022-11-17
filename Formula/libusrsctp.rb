class Libusrsctp < Formula
  desc "Portable SCTP userland stack"
  homepage "https://github.com/sctplab/usrsctp"
  url "https://github.com/sctplab/usrsctp/archive/0.9.5.0.tar.gz"
  sha256 "260107caf318650a57a8caa593550e39bca6943e93f970c80d6c17e59d62cd92"
  license "BSD-3-Clause"
  head "https://github.com/sctplab/usrsctp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1327b9355f6c879443e9a3b8d405559d87ee245e05b435a0fe5257b3d72fd5b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bf65d4cad3f3abcec79432f82c040761b3bf8b5b04417172ea343efc7ff878c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cccdb95cc428680b9dc8c57ae970f23874889797d8438eaa9079e675473ab394"
    sha256 cellar: :any_skip_relocation, ventura:        "f0b2353ab9feebdbd5b7d37551429d7956a4fdf2d7fd628aff589b41da0f9d04"
    sha256 cellar: :any_skip_relocation, monterey:       "3a5ea16561b37ed98f235bd62e33534c85439244a41f3e917ffdabd6c97d74b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca45d1d9431028ad9b7025e6d5486a10f98c6c49e39dd1a4e1d033c75bee6135"
    sha256 cellar: :any_skip_relocation, catalina:       "5c2a6b26e354c0498e0e3ef590dfc9f9651f70ce36112f196baec64ef76aec31"
    sha256 cellar: :any_skip_relocation, mojave:         "fe831b138df6c6b80d260d8a224bf1b1114af51d1b14186e9d714fd99f035e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7b8b7629549478dc7d3b0ca0498cd6c181ce4a94e5dfddb19b34de124621ef8"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lusrsctp", "-lpthread", "-o", "test"
    system "./test"
  end
end
