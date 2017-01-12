class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/mdb-and-sqlite/"
  url "https://github.com/LMDB/lmdb/archive/LMDB_0.9.20.tar.gz"
  sha256 "8ae77a093352d3e894fdfaa387266fc650a04746429cdf303b3d93fd0751d971"
  head "https://github.com/LMDB/lmdb.git", :branch => "mdb.master"

  bottle do
    cellar :any
    sha256 "fdcde37d7b72ef7d2034a72c663cfb218d20a3800fdc2e38ea8bf0ae9580a6ae" => :sierra
    sha256 "0c636ad2fae846054705f014e89b0ad7061afaecd15ba1ef318dd7d4a8fb95a7" => :el_capitan
    sha256 "f4d580f33d301f7c61acae9f0ee5034c4ec6d1a86c8a912fa90205926624a8ce" => :yosemite
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
