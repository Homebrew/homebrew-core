class Bzip2 < Formula
  desc "Freely available high-quality data compressor"
  homepage "http://www.bzip.org/"
  url "http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
  sha256 "a2848f34fcd5d6cf47def00461fcb528a0484d8edef8208d6d2e2909dc61d9cd"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8911d7904862dc4930d024d0459390c510566241015bc06ec97f9e3fbb869101" => :sierra
    sha256 "a22f768ce625a56cc2f4b3c7f08f4b1ba30f79865b786dc4c57a97f672badff4" => :el_capitan
    sha256 "1468f967e8a35954509a8beb40bd29b60b730db158054aeddadc7586890737e8" => :yosemite
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
