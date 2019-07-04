class Bzip2 < Formula
  desc "Freely available high-quality data compressor"
  homepage "https://sourceware.org/bzip2/"
  url "https://sourceware.org/pub/bzip2/bzip2-1.0.7.tar.gz"
  sha256 "e768a87c5b1a79511499beb41500bcc4caf203726fff46a6f5f9ad27fe08ab2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "3376ceeaaacba0847d3e2a38569080606c8ea3b5d7596467abeef0dff74118d0" => :mojave
    sha256 "197655415959a8e856f5926ebbae88715b8aef68fa8612aaf0bfe7e1c96723bf" => :high_sierra
    sha256 "8911d7904862dc4930d024d0459390c510566241015bc06ec97f9e3fbb869101" => :sierra
    sha256 "a22f768ce625a56cc2f4b3c7f08f4b1ba30f79865b786dc4c57a97f672badff4" => :el_capitan
    sha256 "1468f967e8a35954509a8beb40bd29b60b730db158054aeddadc7586890737e8" => :yosemite
  end

  keg_only :provided_by_macos

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
