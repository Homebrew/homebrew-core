class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://www.nih.at/libzip/"
  url "https://www.nih.at/libzip/libzip-1.1.2.tar.xz"
  sha256 "a921b45b5d840e998ff2544197eba4c3593dccb8ad0ee938630c2227c2c59fb3"

  bottle do
    cellar :any
    sha256 "c28e83d87bf7c83b0a6f9acbe1d42088310d7790ffb120515c4eeb4e452ddbb6" => :el_capitan
    sha256 "ad08d1d50f0e5b263ec39253eaec4e70216bef97558a0ec37aae4d7849a1e17f" => :yosemite
    sha256 "e5c8a9203db8983a448ab144a7457b069f560354f2a0f6ee677e89dc4b07c21e" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
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
