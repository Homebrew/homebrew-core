class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/mdb-and-sqlite/"
  url "https://github.com/LMDB/lmdb/archive/LMDB_0.9.21.tar.gz"
  sha256 "1187b635a4cc415bb6972bba346121f81edd996e99b8f0816151d4090f90b559"
  version_scheme 1
  head "https://github.com/LMDB/lmdb.git", :branch => "mdb.master"

  bottle do
    cellar :any
    sha256 "f7d8acade2be32886edf1d039e57070e35db0bdeca6f37ef7f42530ad404cc91" => :sierra
    sha256 "b4dd9a1387599e22744bbb769ce71fd1588e5ea6f1ef1d83a2d32f71190cb6ff" => :el_capitan
    sha256 "66e48198e7bf2a466a614727a71b10e3b865cf1f65451fe10c7d5d4068e46a5c" => :yosemite
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
