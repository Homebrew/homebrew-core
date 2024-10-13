class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2024/sqlite-src-3460100.zip"
  version "3.46.1"
  sha256 "def3fc292eb9ecc444f6c1950e5c79d8462ed5e7b3d605fd6152d145e1d5abb4"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eeb22099bddc4e2e299ce3598beb501f8390b4fcbc649bd9a8c84872bc34e788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3769879ca221369fd3aa1067106f6411466d8c42272f4f9b99833cfd3ab055ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee3a5cc147fd92e4c878de92bd55a21b8c46ef04d8d96917220505d139218948"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dc6ffdbb2f5c7048c2531597d1d19fd4b69844295091efb210849fe6d9f6acc"
    sha256 cellar: :any_skip_relocation, sonoma:         "8040bd63d1f684c9f546ae3526e6344614e6f9c749e2b42e2031ae94b1a76e29"
    sha256 cellar: :any_skip_relocation, ventura:        "336d41a86d22aa25f296a8aef9a47a4fc71db2f5ea53433bc94f24d362df8eb6"
    sha256 cellar: :any_skip_relocation, monterey:       "2a9d362dd1a80fe892b5ef8cc60a29a50e32a950e0349588a118df47c14af4ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fffbaadd7d922ce46a66a9359b12a0f1730602b2d6ed38eab4b4224b20d93a6f"
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
