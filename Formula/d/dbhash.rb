class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2026/sqlite-src-3530000.zip"
  version "3.53.0"
  sha256 "fbc30cdbfcfa42c78fe7bddd3fd37ab8995369a31d39097a5d0633296c0b6e65"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b014c9610922fac5d00c2ebdaea90560510dbd36dda2c84fad1f473b0cb65e76"
    sha256 cellar: :any,                 arm64_sequoia: "c096346c1384e5862ad496fc893d5c16d794548ba2842d5bf5084912ee6aade4"
    sha256 cellar: :any,                 arm64_sonoma:  "b33187ac72c55900a7cd30122db161b92b8d91beaeee7b3992503dd26487be77"
    sha256 cellar: :any,                 tahoe:         "58d9f3959f074586bf26dfecb8b757dc4477aad6e9026f45c7bce379912be800"
    sha256 cellar: :any,                 sequoia:       "b58170d45349526da92fbf9975ac6ad41a2db307fb6f6d7cc7930d52ec63aeb7"
    sha256 cellar: :any,                 sonoma:        "e960eceeae27bb296fb742dd96bb5a570134925f3d338f19a0c71718354752fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "939e5c8e89bb09134d2254603c2593dda2fc067cf59aab15c895fdf1ec566ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "660003c7fc06e3dd0f3e852a844b038886e80af32b166965f3d0ac794cac5103"
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
