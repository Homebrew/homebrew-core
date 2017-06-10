class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3190300.zip"
  version "3.19.3"
  sha256 "5595bbf59e7bb6bb43a6e816b9dd2ee74369c6ae3cd60284e24d5f7957286120"

  bottle do
    cellar :any_skip_relocation
    sha256 "b84582c7c4482e73feff337c2c9191f8438a57dcecc49eff44d2f0a25622934f" => :sierra
    sha256 "386b4759d36f965c3577738be7e4518254283e33d0c83dcb4d63490d832b064c" => :el_capitan
    sha256 "93afa5d8df9d1d2804a4a31f1d5293e3bf93be6d8a9a36ebb44cb9d4b409cf44" => :yosemite
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
