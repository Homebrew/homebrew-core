class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.5.2.tar.gz"
  sha256 "be694a4abb2ffe5ec02074146757c8b56084dbcebf329123c84b205417435e15"

  bottle do
    rebuild 1
    sha256 "7aad5ff734cec8f3c7f71540ee3d16f1423cc9526893d8e60d624f6d22f7dcbc" => :mojave
    sha256 "c3e6bfd3be85c039d1ea40706ce9921a21a2856e2b709dae38c2efb0a3996c37" => :high_sierra
    sha256 "237b9a980bef4463dc1f88c97093312292049f3e6184986179b7e2411337a8e6" => :sierra
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
