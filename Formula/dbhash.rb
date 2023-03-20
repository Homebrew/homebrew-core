class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3410100.zip"
  version "3.41.1"
  sha256 "db929012f9009e7f07960e7f017e832d8789a29f4b203071b4fd79229e7d7a20"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c460446141eb18469645a5a350333dfe836d5449603f7eaa0eb84bf5266de98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04c556a1ef2247b31610bc5b2e9874ea8b635574064e42cb998033e108acc455"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61f2478c9f32b2f5a3ce5e0f6f5f0868a3b08309c2fb497478540c675119d10d"
    sha256 cellar: :any_skip_relocation, ventura:        "6697eb15c632e4e8f14875f81711ce60033d85b54f055635b42fc6eeaf62eec2"
    sha256 cellar: :any_skip_relocation, monterey:       "f572dfde65867e3a2ef0092d4717ec5a943955e62b32de081b812aaaf9857eab"
    sha256 cellar: :any_skip_relocation, big_sur:        "d882ccbc6674103a5ab1b81f2791a3acbcf4688bb5e644e3629285a3adb561cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04dc74f9d799636739b06e3511fa9a47f7465140084c474c7916ff6b0b9664b7"
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
