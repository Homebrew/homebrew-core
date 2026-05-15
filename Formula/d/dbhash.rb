class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2026/sqlite-src-3530100.zip"
  version "3.53.1"
  sha256 "1b2b5755d9064c4d5d1b0bf5307b48b089963e291c40cc7351318aa1b61c460e"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3f6045a8010dd9fd2efc092567cd086f1f7032211a5070f64d3713c884f86f9"
    sha256 cellar: :any,                 arm64_sequoia: "fe6fd26735aa6119bc04c4f60ec4701093fc27ff03b277e5c7db8e84414b7d9d"
    sha256 cellar: :any,                 arm64_sonoma:  "e6aeac201471407bcfcfaa23180b622e9804a113c988046d613984beacb3ecf9"
    sha256 cellar: :any,                 tahoe:         "9ad5574fd5e57d527d4700a3716079002acd681db2abc5a6574b14d8c16f3370"
    sha256 cellar: :any,                 sequoia:       "933de05fa60b15988dc50056818644110f34cdabc87a76454a8e7b21fc573570"
    sha256 cellar: :any,                 sonoma:        "000c82147e94f7cbfc335e12f71dfd1a2aaa4322027a2af8c8c2a6e507457473"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88277365e265ce3f6cac00bfcfbc820207dfe882cc0551f81d63cc63bf555e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11f6c4ac6805f0554c651ad4c9180ce19c86d681a4a991c588fbaa7621aef4c3"
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
