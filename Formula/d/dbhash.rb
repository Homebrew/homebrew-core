class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2024/sqlite-src-3470000.zip"
  version "3.47.0"
  sha256 "f59c349bedb470203586a6b6d10adb35f2afefa49f91e55a672a36a09a8fedf7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9077a6e3fb375cef55da7b42192808f10b89968b7c123da9881b103d5fe2faa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0c01d78c21428c30e484074440c61179d09f85bb305ce6c4505e7383fcd4aa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57bb7738628536fd71a433168731db212eb66a6dbcf91b1832d5c91ad2ed5cee"
    sha256 cellar: :any_skip_relocation, sonoma:        "96d9ab8ff8dc336b34199e054ee9806da4a980596402181b793c5f7ff8f9ac1b"
    sha256 cellar: :any_skip_relocation, ventura:       "e2e895cb8e2699967e09dd05e9656f7cd44a3704f8d668c7c7880cbdc5794279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd86ca62341d80071647559b8d84e0826abe22c6a5ed7d667063aefa761fca48"
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
