class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3390200.zip"
  version "3.39.2"
  sha256 "e933d77000f45f3fbc8605f0050586a3013505a8de9b44032bd00ed72f1586f0"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "935e65566066db81d760dd6eba3e580fcde47778c66b85090d26a875f23c5789"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "890430a66fa6778067a2c8062c185845c5783f11a42fb64657f3f598e80cc6f3"
    sha256 cellar: :any_skip_relocation, monterey:       "b09e7f0178b7cd67fc4e0e9dd0fb0b805724550d2c3a7bb3135fef830dcc90c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaba2b88810f997287c8143982b37f31a598cb9310ae0e3ade79dffe6f4e87aa"
    sha256 cellar: :any_skip_relocation, catalina:       "c1d0b97a72f719936cee9b9879e7f8808076ed4198d2dbab8781e2ba0a728583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f7175e8bf33c08bc4180e0b37813f84cb155e6cbd98b6194edf25ec35927746"
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
