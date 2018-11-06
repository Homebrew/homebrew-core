class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2018/sqlite-src-3250300.zip"
  version "3.25.3"
  sha256 "c7922bc840a799481050ee9a76e679462da131adba1814687f05aa5c93766421"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa66dbae890b9026b3e5319870f6a92a86e49cf2de2db001bbfa8088e96c07ed" => :mojave
    sha256 "e691042a96690efb3c61e34c9b640af67567a3d2200234772bfc6236e756e8c5" => :high_sierra
    sha256 "96c389fa502d2472eca00e1be1a1978d1b4bbb21097bebb3ec70ec5bdc308a63" => :sierra
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
