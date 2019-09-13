class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.5.2.tar.gz"
  sha256 "be694a4abb2ffe5ec02074146757c8b56084dbcebf329123c84b205417435e15"

  bottle do
    sha256 "0036272939932029e74982ae3757ddb3e2a671ea3328f80fbc6a61036396a8ec" => :mojave
    sha256 "adede5bd45b75dbbfb5df7ba638688afa3fa7ad71c84b5b238221fb982bed720" => :high_sierra
    sha256 "58eefd8fef7cdd91803c74c03f55ee161f3b84bdf9785bb693cd901ca5985c43" => :sierra
  end

  depends_on "cmake" => :build

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
