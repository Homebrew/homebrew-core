class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3200100.zip"
  version "3.20.1"
  sha256 "665bcae19f313c974e3fc2e375b93521c3668d79bc7b66250c24a4a4aeaa2c2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c76962454e96b0994b589fa95e7ec28723a1d218b61ba4f4f8aae3d24f443eea" => :sierra
    sha256 "82b9a2b6973ce359e982c1bd3d59f6047d8ef271732af638e9b302d79b202ed7" => :el_capitan
    sha256 "b14a0df464518b466b1169a160b2ce556c9d7427257ea8aeef25b48c30d5880c" => :yosemite
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
