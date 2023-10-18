class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3430200.zip"
  version "3.43.2"
  sha256 "eb6651523f57a5c70f242fc16bc416b81ed02d592639bfb7e099f201e2f9a2d3"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97a4ee5bf146b965d46c9843414802c9142e5c1c4ae11c93e35657c6c8a10cc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6e32db1d0646da10ed2e49f028acb1da2a9129cacc5be80b3e65d854048b685"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bdd3c414c9b41b51fbee1d1fda9998ec169ae92600b7c771a73106d01b1f408"
    sha256 cellar: :any_skip_relocation, sonoma:         "79a37b7ccb16066889d7839af19d4474b2631d7ccd2c168cf425474013e824b5"
    sha256 cellar: :any_skip_relocation, ventura:        "195bd16525cf1cfd1f1857378e6568249017de96ec978926a4a02acd27ea147f"
    sha256 cellar: :any_skip_relocation, monterey:       "fb0131c76a99302cb64d70a395f61ba7120ce675bc77ed735ae574f7dadc2c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e79d66e01a75199d40d1797bd37d0b3bb1ffb64b947a207d3615a60a259468e"
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
