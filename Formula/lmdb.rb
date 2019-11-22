class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/mdb-and-sqlite/"
  url "https://github.com/LMDB/lmdb/archive/LMDB_0.9.24.tar.gz"
  sha256 "44602436c52c29d4f301f55f6fd8115f945469b868348e3cddaf91ab2473ea26"
  version_scheme 1
  head "https://github.com/LMDB/lmdb.git", :branch => "mdb.master"

  bottle do
    cellar :any
    sha256 "5bf964c9e9151652929e829c12079531b458d48233462a42707a2dcf5d0e0ef2" => :catalina
    sha256 "61a2b64ab56431e08dc823fe6381efe8ee6a9d04fcfd90b8c77071442ad02788" => :mojave
    sha256 "19eedd30c27a46e0ec434be2f004e7e82f3541d338bb04d147d98924bb18f66d" => :high_sierra
    sha256 "c8b92ad93c7712f7d45604146b6f3ea848b6c3fd7db21f977971ea74e9a94a90" => :sierra
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
