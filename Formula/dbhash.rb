class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2021/sqlite-src-3360000.zip"
  version "3.36.0"
  sha256 "25a3b9d08066b3a9003f06a96b2a8d1348994c29cc912535401154501d875324"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c8fdda6f47ff0d2f6f4f367f1ae8fdfafd8f115090c6d07a610790aae885adf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93a11d1334f5d87a45445373afe1de1fd99ed87f8dd12a9b02dc92bdcf01735e"
    sha256 cellar: :any_skip_relocation, monterey:       "6b4121bfc0281460baa8e0703578140a73cc304814b8786b7a548c282c7c3c4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "23eccd9d6af0e7e0e23e708bd4697cb3334299a5d7127d763fe53a90aab6d064"
    sha256 cellar: :any_skip_relocation, catalina:       "f7e686231f1748f5655b27cf334fe972a7be8d029a284f291ea2daa8f94c51af"
    sha256 cellar: :any_skip_relocation, mojave:         "56404056dd0a9b8ece371576e64a1b3ad8c9b19f129dd500c38edfbe58c5cccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "036505f744fca371174119931c174fc1bfd73d4772a46983fe40e8cfb7b4d90e"
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
