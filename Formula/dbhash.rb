class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3380100.zip"
  version "3.38.1"
  sha256 "177aefda817fa9f52825e1748587f7c27a9b5e6b53a481cd43461f2746d931d8"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15902c7b416c4f8290f3d6c34155b2d7c7437562ea1704248ea9d1c0c623406a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8c584fe9bd4669880ae0f79ae31bc305699dd8d9b0c9263b1477854b6aa98c6"
    sha256 cellar: :any_skip_relocation, monterey:       "64a0c806ee0608691ff46e94820b918f42fc58d1a0b784975c33bf01a06b905d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3921e7ba23438a099e363d877efc840cc6c04e57eab4487587e97c73c148486"
    sha256 cellar: :any_skip_relocation, catalina:       "34eb60a7a194988f48dfde82d8bcc2da4f3a81941504f990a670e1e83c3fd5ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2456a9b777a97ea77ed6b150dba9dcaf247829dd0ff004e6d39bf4811eaf40b7"
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
