class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.5.tar.gz"
  sha256 "3d5bedd48edb909fe3b87cb99f7d139b987ef6f1616b7e22d74e928270a2fd20"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "e3dd2cec573eb53e225920b027bd63c249ae260a174a42c9f44c1b0e1a582824" => :high_sierra
    sha256 "fcf46a87d6b00803434879ffc5aa6b68176e91424fc5f33f400f88b319f60c05" => :sierra
    sha256 "9ad0fa7fd3f4de11498038b2e37a7e62a07f21dfb091086a171a3e359aa86219" => :el_capitan
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
