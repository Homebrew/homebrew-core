class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.4.tar.gz"
  sha256 "2268a3dff1cc36e18549e89a51ee0cd9513908a977d56d6a1f9d4c61c2af37c3"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "97530ac1acf7239a2cbac6711a2294bcc62e90364d2abc4a2136d042ba121ce4" => :high_sierra
    sha256 "54c0fc63ef52ae05a285b0992d274c0cd5a0b5a8524308f855f8c3a0cc64deb8" => :sierra
    sha256 "67cc90de36dbe23c968b25caec814808f3faf94aa694470663e935a88f341dec" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "VERBOSE=1"
    system "ctest", "-V"
    system "make", "install"
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system "#{bin}/brotli", "file.txt", "file.txt.br"
    system "#{bin}/brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
