class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://www.nih.at/libzip/"
  url "https://www.nih.at/libzip/libzip-1.2.0.tar.xz"
  sha256 "ffc0764395fba3d45dc5a6e32282788854618b9e9838337f8218b596007f1376"

  bottle do
    cellar :any
    sha256 "50ffb3ac27076787296917112d8367d9e37d1e3cb095a8a5f8aaf0c10e66e8ad" => :sierra
    sha256 "fea689c31e3100dea9767f0879b6ac9f263b52a0faeaf457b509d0b696d7fca2" => :el_capitan
    sha256 "c950e33e4db6785c5b23f1c749c61f4fe67f721dae54a46082029f157c85eee5" => :yosemite
  end

  conflicts_with "libtcod", :because => "both install `zip.h` header"

  def install
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
