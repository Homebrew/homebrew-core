class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/mdb-and-sqlite/"
  url "https://github.com/LMDB/lmdb/archive/LMDB_0.9.20.tar.gz"
  sha256 "8ae77a093352d3e894fdfaa387266fc650a04746429cdf303b3d93fd0751d971"
  head "https://github.com/LMDB/lmdb.git", :branch => "mdb.master"

  bottle do
    cellar :any
    sha256 "01ba0974a48a7718969b76976c756b6e2fec4e335dc1d2a8fde852d3e12ef335" => :sierra
    sha256 "b6ac68239ea9d6f68f94b2ddfdd7be38a449f78e00a8ebb35019fa948e255328" => :el_capitan
    sha256 "9414ebf7fc8668e2f7336598775cbe01d5a5c787061461744615879d6166c9be" => :yosemite
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
