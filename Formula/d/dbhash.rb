class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2025/sqlite-src-3500400.zip"
  version "3.50.4"
  sha256 "b7b4dc060f36053902fb65b344bbbed592e64b2291a26ac06fe77eec097850e9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cd5c857d5b3c7b1b4729da7fb1a31d7495d7b9510946ea817d94d86811acc1a"
    sha256 cellar: :any,                 arm64_sequoia: "03ec5a59f4028205cfb489469eb1ea3f809b188e8ea33893c23223c4c2c27fc3"
    sha256 cellar: :any,                 arm64_sonoma:  "67033dfb28cd954f57f06c5d805e4fd2ceb0e1c2845e5412650a90da5b475033"
    sha256 cellar: :any,                 arm64_ventura: "ecf3c1db5545e7834176ffbadebd6765a5bfbac6e945d241be4cbabd83f931e5"
    sha256 cellar: :any,                 tahoe:         "a15856ff4813915838b8c78f4a2b83fba138c5f7a87a8b08c72571e6b625dcf4"
    sha256 cellar: :any,                 sequoia:       "15c3d7c8ac7609eabf238953fe218796dd6840c6b56aac07edf829dd09640ff1"
    sha256 cellar: :any,                 sonoma:        "084b6b0ea8b6fe7befb8f1f106103c3652eaa7acaf2059e661f89706823c5f8f"
    sha256 cellar: :any,                 ventura:       "3692e62a8afd45243951f3ab2be729521efd7453e2c6728938f4978984f25e9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8aab1565a476ee250ddd7d075ff7582c22e65c21f3a125d3f52d1f587c963f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4df125f697bf1d1aade0a1c4d90f44cebdc610a383c8dc470f290a465cd47144"
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
