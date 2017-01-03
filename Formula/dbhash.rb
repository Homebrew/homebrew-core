class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3160100.zip"
  version "3.16.1"
  sha256 "490f0c27dd29cbc96df5b6750dcef18a9da5e31b3608fc241354f38d7af0a942"

  bottle do
    cellar :any_skip_relocation
    sha256 "05f9aaaa1ed3859da9837d1569b1d4791b2b564a2fee4eda9d047dad6f64cad5" => :sierra
    sha256 "f283e935f6ad55ede2f1163da9f0bc05cdf9d558c353b35b9530d90ba2b90e28" => :el_capitan
    sha256 "55212fd3993937535432eb2e3fe72ece403b03903671f22fcfcb75bd788b8e3a" => :yosemite
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
