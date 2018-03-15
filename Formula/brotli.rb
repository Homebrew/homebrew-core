class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.3.tar.gz"
  sha256 "7948154166ef8556f8426a4ede219aaa98a81a5baffe1f7cf2523fa67d59cd1c"
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
