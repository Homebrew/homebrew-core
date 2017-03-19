class Bzip2 < Formula
  desc "Freely available high-quality data compressor"
  homepage "http://www.bzip.org/"
  url "http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
  sha256 "a2848f34fcd5d6cf47def00461fcb528a0484d8edef8208d6d2e2909dc61d9cd"
  revision 1

  bottle do
    rebuild 1
    sha256 "ceb1aab63302975659889ec645a55aaf4a60d93f296765eba2066c15c80ecb03" => :yosemite
    sha256 "e8e0614bfb9f2db7d42d3d7111e5d0f92ab4694a6a1717b1596a46ef5daf19cf" => :mavericks
    sha256 "524193536215c58e833703505bad765ce3a29388cec34c29c611f800a53f0874" => :mountain_lion
  end

  keg_only :provided_by_osx

  def install
    inreplace "Makefile", "$(PREFIX)/man", "$(PREFIX)/share/man"

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz2"

    testfilepath.write "TEST CONTENT"

    system "#{bin}/bzip2", testfilepath
    system "#{bin}/bunzip2", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
