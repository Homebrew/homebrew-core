class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.7.3.tar.xz"
  sha256 "a60473ffdb7b4260c08bfa19c2ccea0438edac11193c3afbbb1f17fbcf6c6132"

  bottle do
    sha256 "2acdf43a976beae67dd1a1c8c17da3ea33e3097e091911edf58236afe811d599" => :catalina
    sha256 "736d1a207d3f30d27b7b52c11ab6bb2bc41ac24d45a2ff9d603070e336e1689d" => :mojave
    sha256 "8d62e6ba9e16d6eccc1ee41b979571a593cfb0074944d92fecf24411ac7e3545" => :high_sierra
  end

  depends_on "cmake" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  conflicts_with "libtcod", "minizip2",
    :because => "libtcod, libzip and minizip2 install a `zip.h` header"

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
