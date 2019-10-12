class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2019/sqlite-src-3290000.zip"
  version "3.29.0"
  sha256 "a1533d97504e969ca766da8ff393e71edd70798564813fc2620b0708944c8817"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0ac459553c2bd9501beeb80ebbdd07cc150574801b94217515006b0b69fd2dd" => :catalina
    sha256 "a1d2bcecc4090492c45e4824611b50f03570c04a30993794198805b81513f5d4" => :mojave
    sha256 "a00d65241d0acf4bfcbf8215fe4ff43e756e10a8a379a59d43d86f36c8620400" => :high_sierra
    sha256 "5f878830dd1ddf2b95054eebba1908ef5d200059352902f306654a848ed09a23" => :sierra
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
