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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce1728ae6c35b1b61eac82ffa913ed5ef2f17661315a1c3db075c94d7f835a50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cbe62078a31e8fa15a36bbbd2f5ef2e9216bbfb7c975316d0da0e1b3cd1ecf1"
    sha256 cellar: :any_skip_relocation, monterey:       "a81ed46492e61cc427f17c0253175f56b1496318beea0f7e4fb0636e4bc693d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2f6ef3367858dddbc0ff62be64070fba3cadd40bd3510de81de8aa332bc8322"
    sha256 cellar: :any_skip_relocation, catalina:       "c7cd25cd903fa6cb08a30bb5e32b6b1bde5539bc30f88332e33ac17481c325bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10034cc725f341a6575dea6c88903cb1712516197099bffeaf3da652b140b62e"
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
