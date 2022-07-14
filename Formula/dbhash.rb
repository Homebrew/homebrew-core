class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3390100.zip"
  version "3.39.1"
  sha256 "366c7abbee5dbe8882cd7578a61a6ed3f5d08c5f6de3535a0003125b4646cc57"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb08582218f18757c38bd272d2287df9a406109429fc6f990d848c6769667fd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e7f613aac1a88332b93358a2905e702a9eb1eaededd4feefbece13c8e77292b"
    sha256 cellar: :any_skip_relocation, monterey:       "ca6c7fd4ff486ed997b93414fc515b19e2e7743f6f2b2b22cfaf7d044eb41ee7"
    sha256 cellar: :any_skip_relocation, big_sur:        "abe68293195b2195a3c7b0c650ba4af4edebd2e16182c82a3a6a6b8cf8572df0"
    sha256 cellar: :any_skip_relocation, catalina:       "0e4770e822b75facd493b8b20aa8cdc05537349d7d449ad00a4dcd8d8e38f4a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e80c78987c33d080cef569fd1a84cacf0d1eb5db95929822cedc4f40188e861a"
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
