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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "922e82aeda4e139dd5d3921519bda8e11b2eb56da9a71783c762b2bc1f959131"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d21f448facbd170dad9ca667c18514a0476cbdad0c6338a533d2fd04cb4d97e5"
    sha256 cellar: :any_skip_relocation, monterey:       "d3eca7b2fa707d632177107446d8584b849a6d7fc5416cb3dfd59e7da8f369b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f2972737b46539395dcce83ace75849c12512332174ee03ba8c4ddacf14c153"
    sha256 cellar: :any_skip_relocation, catalina:       "2b5c46ecf2084bbbf006c0e310ea60727a62feee33921c1728bf591ae5e9f158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f997fd141f9cc967b7992312db1a26cb113def9e73aba07f5043f81f54a8280"
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
