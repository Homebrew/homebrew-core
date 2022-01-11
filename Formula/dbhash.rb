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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9b1e4077c59c9a0ed75d9a69d094fd705610657a946bfad019d219ccaa0040"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "736f04b5e555d421140d1d5b5bb23f5234ffc87476a925b7be96b1c14abc4533"
    sha256 cellar: :any_skip_relocation, monterey:       "88923132c6c6f10c0ef0a222131074e037833103328f5f6bf910342e8cf73f62"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfa9541f7fa351cbfb29fa8f40c0da6c727893577f30489ea896c1a5ba9b72d1"
    sha256 cellar: :any_skip_relocation, catalina:       "6de0ccfe56d4098c6c750332115763644b303cfeac53585f1d884e8e33fe16ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7534edc8fd2ab634b0b6d5df6c93fffb24be99bed374e0ced7eb70c6d567a98e"
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
