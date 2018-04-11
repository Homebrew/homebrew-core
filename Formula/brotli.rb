class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.4.tar.gz"
  sha256 "2268a3dff1cc36e18549e89a51ee0cd9513908a977d56d6a1f9d4c61c2af37c3"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "5b1ea08d06845a2d11516b5ccab54fa42f9716f72d893ae87920527a044c9ae4" => :high_sierra
    sha256 "ba9bbd43aa4219408c007166005651568b03da3a4fc6590a5b7e4e45585e537c" => :sierra
    sha256 "3cdd9cb0eeada350c4047f52007c4cba157b5d0411b3bfa00100cf641696518a" => :el_capitan
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
