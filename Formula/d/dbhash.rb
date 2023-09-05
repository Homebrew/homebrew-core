class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3430000.zip"
  version "3.43.0"
  sha256 "976c31a5a49957a7a8b11ab0407af06b1923d01b76413c9cf1c9f7fc61a3501c"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "293a19dda220ed57b60d268b853245a106ee17571d40dca46cb5153492f78f38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e2fd9e71a9e7037cc368164de182872ef5a8b1292c8acdf63bf306562a52538"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d244491d125ed912480a948cb9266ac377d73b566557d37b6c0427caa1209fd"
    sha256 cellar: :any_skip_relocation, ventura:        "a22fc43a54a73a3020703062083e06f2e00c52e83b06e801493f991bd1671ae6"
    sha256 cellar: :any_skip_relocation, monterey:       "879ecbd263f794383df3461e19ec0c1b4b2faa08359f97ba9be029eb5b9a3ddd"
    sha256 cellar: :any_skip_relocation, big_sur:        "adf601868134df1dd8d7d8f3cbece423b4cb073eece0ce9645210a6e2586393d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9f178b2abe2a262dc42ffe5128e04d840863c7216ac43caf7110890c57bac2f"
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
