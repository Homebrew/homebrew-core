class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2024/sqlite-src-3450200.zip"
  version "3.45.2"
  sha256 "4a45a3577cc8af683c4bd4c6e81a7c782c5b7d5daa06175ea2cb971ca71691b1"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c43cd28081496c561817221fb7003d769962b4d154dcb6064e04bb5d81b96b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94424d506d7a82a5ba062de13e301c094d92276217c31b2a5192240e7acb191f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82871eaef1a4150627d012a29a5fa496e4f32fd2ddc5e118cd6007ebe1ae1e77"
    sha256 cellar: :any_skip_relocation, sonoma:         "f79ac692973c4e7d00ed0b7d3ca532ccc18c8b25f2a8f6e0d8e81ece77e22f88"
    sha256 cellar: :any_skip_relocation, ventura:        "1e2efe239a022d66dd6eb8584364a4bffa407bc3bcbdb78318225b2ddf847aed"
    sha256 cellar: :any_skip_relocation, monterey:       "e76103b82b1a410315729db761c6a00b8405a60dc2c7fd9e2a4f2fd0e9c10d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f6207af5efe9346e478eeb95875f2cbecc91a66f5ef539fc02e55032a0b7859"
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
