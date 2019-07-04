class Bzip2 < Formula
  desc "Freely available high-quality data compressor"
  homepage "https://sourceware.org/bzip2/"
  url "https://sourceware.org/pub/bzip2/bzip2-1.0.7.tar.gz"
  sha256 "e768a87c5b1a79511499beb41500bcc4caf203726fff46a6f5f9ad27fe08ab2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e2b2fd73f5cc63d50278b89a66da9313b058e43a5621a9a61c204b908f3af18" => :mojave
    sha256 "0c791995ffa600c0f5d2d6566619ceffd309fee6f45b867bb0823e5812dc9425" => :high_sierra
    sha256 "48ba103cc8c92c4f63f0ff8557368d73625e767908accd69ac830df840b8561a" => :sierra
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
