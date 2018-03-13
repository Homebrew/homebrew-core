class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.5.0.tar.xz"
  sha256 "5ddb9b41d31b2f99ad4d512003c610ae2db70e222833aba6f9332d5b48a153d9"

  bottle do
    sha256 "f0d016f7ca888b27d0880ca2f7786a37a00ced32e245a8e42cc3c16110d40fc7" => :high_sierra
    sha256 "7eaa32231483a97b9702cbd5a8d7df262bfb2a05a6754602bcff61eb23ac4c98" => :sierra
    sha256 "db917258649b9a889d1f1f60b712a3a80e16e4785620ae08d2115562425cffdd" => :el_capitan
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
