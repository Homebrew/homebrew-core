class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/mdb-and-sqlite/"
  url "https://github.com/LMDB/lmdb/archive/LMDB_0.9.23.tar.gz"
  sha256 "abf42e91f046787ed642d9eb21812a5c473f3ba5854124484d16eadbe0aa9c81"
  version_scheme 1
  head "https://github.com/LMDB/lmdb.git", :branch => "mdb.master"

  bottle do
    cellar :any
    sha256 "cd79dd93c2b5bc239f289cca47fdfec22cdb394f24ae661e15a8b5446f1ce2f2" => :mojave
    sha256 "74974a9c57215435e9d2e91b8d401aa2c4d6343c4fe0f574355cf3853b292dc8" => :high_sierra
    sha256 "f05c8fd72dc3b751920dbd370e6aa5bbc643bbb3379a7819c0a1da4befe08fed" => :sierra
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
