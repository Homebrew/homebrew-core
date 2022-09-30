class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3390400.zip"
  version "3.39.4"
  sha256 "02d96c6ccf811ab9b63919ef717f7e52a450c420e06bd129fb483cd70c3b3bba"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78cbb1ea9b6275d7c0393a320eb5a9a847224a8145b8ec30c79da3d51288885f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d0b1bd6169e534e07159b5ee0bb3eb21f90d5cc9e09134e76d3178c9b5d628e"
    sha256 cellar: :any_skip_relocation, monterey:       "432f063743bc5a2009641f7a81e010f9e7496a098593880b0fb3e503466d19bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "49e7458b88294baf8714bc70adbb3e8f44dfc320049022eb141fda948432ec88"
    sha256 cellar: :any_skip_relocation, catalina:       "8750ee62039a9ff309d392a85304709bacdf413f34c7347da03887e31f450e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c02ddec622bf4f133e9aec18558d5cd3bcab05b4066256b0450c24d90a2f373c"
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
