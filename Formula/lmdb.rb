class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/mdb-and-sqlite/"
  url "https://github.com/LMDB/lmdb/archive/LMDB_0.9.22.tar.gz"
  sha256 "f3927859882eb608868c8c31586bb7eb84562a40a6bf5cc3e13b6b564641ea28"
  version_scheme 1
  head "https://github.com/LMDB/lmdb.git", :branch => "mdb.master"

  bottle do
    cellar :any
    sha256 "b93558612553bb8ee487b9ff433b89316b5908acf0cddee2830b2198d2876367" => :mojave
    sha256 "446eacbb6ae70705b8ef850a143a19378f840ed4070a6beb7ec80c0876913987" => :high_sierra
    sha256 "5eb74dfb0f982df132fb1c4edd45de857cba72bf461b213c4565b54a8cb9fe67" => :sierra
    sha256 "6ca8e50908dfd7feb3e405c6f348a950c798747d57d02bd426e76b1cf1b8500f" => :el_capitan
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
