class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2025/sqlite-src-3510000.zip"
  version "3.51.0"
  sha256 "5330719b8b80bf563991ff7a373052943f5357aae76cd1f3367eab845d3a75b7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20d5f4a5f9d0ceb6070f34c36ede65279b245b10fc63fdcc47740b9822f707e6"
    sha256 cellar: :any,                 arm64_sequoia: "bda237b651ed1528ce868f63a2bc834510ba62779fb1184ba0101d3eef0492fe"
    sha256 cellar: :any,                 arm64_sonoma:  "9573fb454994e50e6de242f9db21d2fa1a64706b9fcb77aba3b1d9249f7a0b95"
    sha256 cellar: :any,                 tahoe:         "94c3281de17699bcbce6882ba696f83d494a2ec66cce275ba3a103e25ce937f4"
    sha256 cellar: :any,                 sequoia:       "0fee4affa3cda23faff3ae1d85e17234b1be9f463d02833858b703f2b4c2f74d"
    sha256 cellar: :any,                 sonoma:        "df8dfae82828fbbaef2e89409bfe539c11110af18522f8282af66bcccf4b762a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2f7bba55e7e70647fdc0abf13f52d1957fbf7321fc32336df1dc5ba38f55bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f58b9d60233a60b6e8a90d50513698a026b86b05530070a70bf9fa0109f06dca"
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
