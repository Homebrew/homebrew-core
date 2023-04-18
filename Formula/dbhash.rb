class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3410200.zip"
  version "3.41.2"
  sha256 "87191fcecb8b707d9a10edb13607686317d7169c080b9bdc5d39d06358376ccc"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7de2e44882e963a96d2782d668997054306497ad0a172467d9f58a98a9655094"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f217501d2e7e85f95e8b924abbb515d648f571fbf8fd285550594e480eb3e2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c0c48b7ba727abd90fb073f9c2e7f93f02ee6cf535f9b2ddd9b920591227fa0"
    sha256 cellar: :any_skip_relocation, ventura:        "6fb04e3eb4f14526df223d3997714d2c4f62eaaeb3f0fc7acc5ed44070b63937"
    sha256 cellar: :any_skip_relocation, monterey:       "691242c6096a815601d951d28fb83b1842cd81da5d4da4be2311d0c0ab96d2e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "96bf4894fccf39347b61343636ac2e1e04d53c550c6358c43c89eeb92a28a155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f78d536fed0de0f47ac26122447dab6c2389f9ff3cfdcda7e931e9b2aad5a799"
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
