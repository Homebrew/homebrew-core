class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2024/sqlite-src-3470100.zip"
  version "3.47.1"
  sha256 "572457f02b03fea226a6cde5aafd55a0a6737786bcb29e3b85bfb21918b52ce7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88729777437729f24a82d7b89339d8c3e1805e34ca0e698e90113e0bdd6443d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a69dcfd3da041081b2218001d55dee53e84a0c9efefba9e0520c2d6418a0342"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a68c438309a0b537f87252afcabdb3302e0371cf0266378b4777cb2de5ee588b"
    sha256 cellar: :any_skip_relocation, sonoma:        "223196d7d489952aedaec3e2e3e4410267aea4475a903894ba8d07bf2e186720"
    sha256 cellar: :any_skip_relocation, ventura:       "14cf3b43a1bd881cdd640258f918cf2404fbb144d7348bb21005f0b13e8dd53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238bd513958400b6689ab8bd78f77adbf3b8c621673fdd45ed01a2e488b9745c"
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
