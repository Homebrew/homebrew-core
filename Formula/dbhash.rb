class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2021/sqlite-src-3340100.zip"
  version "3.34.1"
  sha256 "dddd237996b096dee8b37146c7a37a626a80306d6695103d2ec16ee3b852ff49"
  license "blessing"

  bottle do
    cellar :any_skip_relocation
    sha256 "e78748b9512fe5d161c20d55a2eb5e8a7b98228a3d5f1e56d771cc4b5dbbde01" => :big_sur
    sha256 "dc05a7c0eb96abe7c0f51e68b6ec288413472c19e4f213a6247e5f9bb8fb538a" => :arm64_big_sur
    sha256 "e7862278eabec401be43993176c6384e70bda25fce16b410ef2b7e5330887129" => :catalina
    sha256 "e60d82423d9fe99f0aa894a4548ef56c8ef760303e8a30feae6000f31f12946c" => :mojave
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
