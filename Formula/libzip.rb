class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://www.nih.at/libzip/"
  url "https://www.nih.at/libzip/libzip-1.4.0.tar.xz"
  sha256 "e508aba025f5f94b267d5120fc33761bcd98440ebe49dbfe2ed3df3afeacc7b1"

  bottle do
    cellar :any
    sha256 "0688a0cf6f6f88fd4b7aa563057e261922888f58f267f0899034c683e1d526ad" => :high_sierra
    sha256 "4851da6bbf50facbf02119cce0f3dfabd0947f44f95a1479652c4e79121e3670" => :sierra
    sha256 "22ecf2b59e06347de384adf7b635dd3dd3d7b0ac07328bf652eb7a12e74ac674" => :el_capitan
    sha256 "132e57785f7973dfd451c8f44794a93e38f9f2040c0779b9eff6ba5a1f81711d" => :yosemite
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
