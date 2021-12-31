class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2021/sqlite-src-3370100.zip"
  version "3.37.1"
  sha256 "7168153862562d7ac619a286368bd61a04ef3e5736307eac63cadbb85ec8bb12"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f6bf29a10b241b586f159c9d3613466228a2266c4c6528eb52a993b23b9eb44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8811e317b4c803223d6453e30f2d632d9aaf6656f5011cd83537b9f363d34b8d"
    sha256 cellar: :any_skip_relocation, monterey:       "a415ba009d76f052a46ccca4083b67904d2220c3f274cf8c4bdc95991e3759fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "19c216e5f189183306af7edd52e632204a2cd28c8185c23cd9234a50d9df47ff"
    sha256 cellar: :any_skip_relocation, catalina:       "403f7f10e3ad049375042119b0c27c6a1c6dc95b84ed34a0c09117b9ee1fbfc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4544f7acc745cfdf51550e2c99dddc86d7da8a24ed256e12a6bc15ed561d4f1"
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
