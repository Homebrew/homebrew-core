class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2026/sqlite-src-3530400.zip"
  version "3.53.4"
  sha256 "d18fa15aec74d8c17e1463f861095adc01b5ad190256acb4f91d22f0368d232b"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "62142af6e4ae3eabefce706e5dcf45b3c5808c3c38f6212d8384cb3b3e2bda46"
    sha256 cellar: :any, arm64_sequoia: "701983f5975550e14ad8e825e61b79c4792bc4431e5fea4be90075b1abee8a1f"
    sha256 cellar: :any, arm64_sonoma:  "fa4f33c5f22b95e43a8332deb84baf63014de4204681a9f24993ced1e7220708"
    sha256 cellar: :any, tahoe:         "16d24cdfba5151a3b92b1db684300177b1e40ee0d84b03906310b0d56ab7ba41"
    sha256 cellar: :any, sequoia:       "57484726365426aafb623ff456581d3d7ed15490bc21bd69617ff2eba83de18e"
    sha256 cellar: :any, sonoma:        "2cfef1b20340970feb6133a7cdf83ae1987840961b1ff3c89fbf0257cb5531f1"
    sha256 cellar: :any, arm64_linux:   "bebd2feaed95cb8364db222b40959d3e229cf86776c6ed1047fabc53c1ac5f4f"
    sha256 cellar: :any, x86_64_linux:  "4af0bec0ac08edb0f5eff633c2a6e87022b0bf52a87eec8cf4015af1d08a6fe1"
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
