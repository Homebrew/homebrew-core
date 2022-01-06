class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3370200.zip"
  version "3.37.2"
  sha256 "486770b4d5f88b5bb0dba540dd6ee1763067d7539dfee18a7c66fe9bb03d16d9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "342d2b38433e27448084cd3e1c7f916a4068ea4a2fc51d1018edaf39c7e3e360"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "203d5aa2906834503ee95b64c6d581d3356948a88c917bff4e4106c83b5aa175"
    sha256 cellar: :any_skip_relocation, monterey:       "d302baa514e5624d45c99906175b4d62752072713fa521758e219977e3e004de"
    sha256 cellar: :any_skip_relocation, big_sur:        "a94779b8f8b33bdf17a63608d2018888796a65f7e62f2b705105d0ff2cf1b7a3"
    sha256 cellar: :any_skip_relocation, catalina:       "9e3c672e63a326a7a001d79e9a3e5588b9200ce3cde8bb20d9659d109723ed5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "634295e5d6af58f58c6502c95a9cb26c8f5d4e00c3fc946564d6cb62b9c23020"
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
