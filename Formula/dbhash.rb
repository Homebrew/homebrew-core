class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3200000.zip"
  version "3.20.0"
  sha256 "4b358e77a85d128651e504aaf548253ffe10d5d399aaef5a6e34f29262614bee"

  bottle do
    cellar :any_skip_relocation
    sha256 "b618f5e68171440933eb69493b5322e3d5c6ecf2f40fc576c64aa5a3fa4a1bd0" => :sierra
    sha256 "4cb08991a285adadfe18ddc1b45afc89fb59ccaf8639b2ad524856911a6aeb06" => :el_capitan
    sha256 "292d601cc051e8483401637327f1161d0a382f6772bf270086a675c7f1ac0ec2" => :yosemite
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
