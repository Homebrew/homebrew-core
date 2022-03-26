class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3380200.zip"
  version "3.38.2"
  sha256 "c7c0f070a338c92eb08805905c05f254fa46d1c4dda3548a02474f6fb567329a"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35c747bdf0146af29a4b2b4af1904d99128eec397d6e3948e1dd1b995585707a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cc580a3906fc58e50b1cfce2cef63f0c7a65ef52af741c243257ed1bfaa709d"
    sha256 cellar: :any_skip_relocation, monterey:       "dfa72be3472e7bed4cd464c5dfd7ad832198587ad2d167256767775e7e092c7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3c447ffdbbc1fe28b25af757a1058aea6a7d31c1351337a59fdaae5837177bf"
    sha256 cellar: :any_skip_relocation, catalina:       "c713a57ff08feb92f8475acbdbc5029023634f698b8b0b11c6683ef4bf49032c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da0d6591e78d73032ba11ba857c3d7535f9247f5bad07e4d8ae5d6f3f7e69c9f"
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
