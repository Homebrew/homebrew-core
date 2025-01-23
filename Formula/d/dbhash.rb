class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2025/sqlite-src-3480000.zip"
  version "3.48.0"
  sha256 "2d7b032b6fdfe8c442aa809f850687a81d06381deecd7be3312601d28612e640"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6ebd2079e9cc3a6362f66c4e06a0ae326972d758c0efd5b43fbd7f12dba070df"
    sha256 cellar: :any,                 arm64_sonoma:  "652a704bf54c3deaa06c06e6d3fc040461cc0c945ad9880d8277d60b9cead507"
    sha256 cellar: :any,                 arm64_ventura: "bd790c212dde0493ebc54f85d7ad9d6084cb1b18355331a557c4c0706ff84c73"
    sha256 cellar: :any,                 sonoma:        "ab19b6eb7ecb9d9b7915ab0f308f1f109fc68f77feea6b06db1f1f8d2c363296"
    sha256 cellar: :any,                 ventura:       "1086859f60c7e71a3509000f0e5f1c326749ea5635612bab29cfb8b8eaa0788e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "677b60876d0dceb2a9ad6def5320c062778446993857ea92344fe8eec9d13435"
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
