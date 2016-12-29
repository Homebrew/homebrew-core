class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/mdb-and-sqlite/"
  url "https://github.com/LMDB/lmdb/archive/LMDB_0.9.19.tar.gz"
  sha256 "108532fb94c6f227558d45be3f3347b52539f0f58290a7bb31ec06c462d05326"
  head "https://github.com/LMDB/lmdb.git", :branch => "mdb.master"

  bottle do
    cellar :any
    sha256 "3937af8efc92e6786f5f6406ea02a04036cf0ecacf4ac31705486792073e644e" => :sierra
    sha256 "daed319fbdae70b79a6413fcd0c6d17df2cf1a5ff8ed80fcd3ae3c6820cdfcef" => :el_capitan
    sha256 "0aa8da475dd4f4f8cd0500244d37f3f301d4c50b96bca133535906f3a2d1a0f2" => :yosemite
    sha256 "d08670a1b23fcea78ed3f192772c28ed1b995249aeb61e0b50391abb01d66f72" => :mavericks
  end

  def install
    cd "libraries/liblmdb" do
      system "make", "SOEXT=.dylib"
      system "make", "test", "SOEXT=.dylib"
      system "make", "install", "SOEXT=.dylib", "prefix=#{prefix}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")
  end
end
