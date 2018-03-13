class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.5.0.tar.xz"
  sha256 "5ddb9b41d31b2f99ad4d512003c610ae2db70e222833aba6f9332d5b48a153d9"

  bottle do
    sha256 "87ec1783c506af77d1d22f7a9a7d2d707f1a3f42588c70bafc09ea5be2e04bfa" => :high_sierra
    sha256 "e25e79fabdb933b91d1f831b8682f739514d076c4680e54bab2bfe2cb7c9c576" => :sierra
    sha256 "95ddeac17446e46071b862a9c2e83620039bf71ecb61cf39e857106fddbb53f4" => :el_capitan
  end

  depends_on "cmake" => :build

  conflicts_with "libtcod", :because => "both install `zip.h` header"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match /\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1)
  end
end
