class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/mdb-and-sqlite/"
  url "https://github.com/LMDB/lmdb/archive/LMDB_0.9.19.tar.gz"
  sha256 "108532fb94c6f227558d45be3f3347b52539f0f58290a7bb31ec06c462d05326"
  version_scheme 1
  head "https://github.com/LMDB/lmdb.git", :branch => "mdb.master"

  bottle do
    cellar :any
    rebuild 1
    sha256 "31c30590d1d685e7418d45b50b5e636cea5ea5147b472172ff4f809686297892" => :sierra
    sha256 "655ec022ac655fde5a3c88ca4b71c0c6942a0c758e12262d495d15747fc65ecd" => :el_capitan
    sha256 "36f056edff5219f3efca010d290f8882d5dd053c10cf8f1d673a7a6477f7b20e" => :yosemite
  end

  def install
    cd "libraries/liblmdb" do
      system "make", "SOEXT=.dylib"
      system "make", "test", "SOEXT=.dylib"
      system "make", "install", "SOEXT=.dylib", "prefix=#{prefix}"
    end
    (lib/"pkgconfig/lmdb.pc").write(lmdb_pc)
  end

  def lmdb_pc; <<-EOS.undent
    prefix=#{prefix}
    exec_prefix=#{prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include

    Name: liblmdb
    Description: Lightning Memory-Mapped Database
    URL: https://symas.com/products/lightning-memory-mapped-database/
    Version: #{version}
    Libs: -L${libdir} -llmdb
    Cflags: -I${includedir}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")
  end
end
