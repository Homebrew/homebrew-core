class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3190300.zip"
  version "3.19.3"
  sha256 "5595bbf59e7bb6bb43a6e816b9dd2ee74369c6ae3cd60284e24d5f7957286120"

  bottle do
    cellar :any_skip_relocation
    sha256 "a74a68acce9b50322f7f6a6ea22d13432152897b20ec829efee9fee54a14cfc0" => :sierra
    sha256 "7bab3f163e760793b4490b4d4c964a0aa621b623c6df843c0eff692654a81160" => :el_capitan
    sha256 "b5e0556b7bf216b13f8b1199e9fe572297796d086247789699d36c28a553a8bc" => :yosemite
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
