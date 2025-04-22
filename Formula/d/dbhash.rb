class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2025/sqlite-src-3490100.zip"
  version "3.49.1"
  sha256 "4404d93cbce818b1b98ca7259d0ba9b45db76f2fdd9373e56f2d29b519f4d43b"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "88764608e548191d287cbb49c35a1a7a15a74d3101384056a4056228a953df47"
    sha256 cellar: :any,                 arm64_sonoma:  "fd18905e491cf4908799fba763a5ef502d1cec96c30a3e88ab7b0e4061bcc91d"
    sha256 cellar: :any,                 arm64_ventura: "06e32bde8bb0c06631d5255c52684e8f0f414e1b402805f48341f00338e0d417"
    sha256 cellar: :any,                 sonoma:        "91f666f5d3eb31817d0982b8ada162d6c757521368f68da458c0a299daa70a1a"
    sha256 cellar: :any,                 ventura:       "c16609885320710ae400fe53ea69225bc69bad698f9d08d6791b26293111ce55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b608c5cf65092c411815c0c8005bba6dfa860686a665e452e0705a0ef8794ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab54fca54a347b624a5c6d67c9964d547bf815a503264f854986e4b053c8a936"
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
