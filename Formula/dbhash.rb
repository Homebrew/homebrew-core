class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2021/sqlite-src-3340100.zip"
  version "3.34.1"
  sha256 "dddd237996b096dee8b37146c7a37a626a80306d6695103d2ec16ee3b852ff49"
  license "blessing"

  bottle do
    cellar :any_skip_relocation
    sha256 "0749d1a47c9c62364004e492687b7e884d6beae636a16b310400074d6ab412ad" => :big_sur
    sha256 "5c1f600e1c3b9a4dffda17d135c5451a6370a66e929907cd542482bd9b78c00d" => :arm64_big_sur
    sha256 "33915e5efb31f85f70b224a895ec7d559ace851bb2db908e1ad9dfd7e7e48689" => :catalina
    sha256 "58bdc1479bae920500e6f3193094b08ee4ccbbf34d209a4aaf89b86bec2b449d" => :mojave
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
