class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2021/sqlite-src-3360000.zip"
  version "3.36.0"
  sha256 "25a3b9d08066b3a9003f06a96b2a8d1348994c29cc912535401154501d875324"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c7c7eebca675d25b8256f40b9b1968b6277ab163f2c275c9414ff03638e5ccc"
    sha256 cellar: :any_skip_relocation, big_sur:       "089ac0935340a12203e164370650e7811465d3b8bd040f5b69e1597953dfba8f"
    sha256 cellar: :any_skip_relocation, catalina:      "7a692257948fb631fe4279c9e74537304ad6a5fec196d97b6afbd1d846776221"
    sha256 cellar: :any_skip_relocation, mojave:        "90ef9bf06740ac7e40e18ec65b9cddeb948b030afcb7c51db0dcb0bf241a297e"
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
