class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3380500.zip"
  version "3.38.5"
  sha256 "6503bb59e39ec8663083696940ec818cd5555196e6ca543d4029440cca7b00d9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38dd0068f28d1117a2ba23510f1abd147a8321b214c134a1287e9b1d2f96f404"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a582166376e1379843fd9bef5478ba0bab146260dd2bef2a972bb307d9974f1d"
    sha256 cellar: :any_skip_relocation, monterey:       "2aa6e024325a79d7460f4dcf37c8280c9f4f90ad4b881f1602c2d56199ffde04"
    sha256 cellar: :any_skip_relocation, big_sur:        "59ca4b9d07c6445348c4455e31840ada6a083d3d508a4b4da0113404c35654e5"
    sha256 cellar: :any_skip_relocation, catalina:       "9a33085b32a8b1fd06171c833bf5835b66aa0b6af6d88f6f5562ab380ec71da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13e6db066f7ac8293704f53d46c2150853657377747cedfab415c8fe4131461e"
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
