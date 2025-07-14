class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2025/sqlite-src-3500200.zip"
  version "3.50.2"
  sha256 "091eeec3ae2ccb91aac21d0e9a4a58944fb2cb112fa67bffc3e08c2eca2d85c8"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2b8cbc711f308b77c7fb2016cbe4212c0bdc6256b6de25fb452ffc8b05a483da"
    sha256 cellar: :any,                 arm64_sonoma:  "c3a8b46d3283c31788789e04587af45221e23695c5cc7e6dec400eab9dd56e8e"
    sha256 cellar: :any,                 arm64_ventura: "f7b2e93dd041a95abc76eff427c077167ad0d95de497cc1ba69b6c19ffe5efa0"
    sha256 cellar: :any,                 sequoia:       "fe345da4e12fcd82448c86b8446f83f2be6c2db7121eb9f2384ef2d437683349"
    sha256 cellar: :any,                 sonoma:        "f66b4cd7f0fec535e8b6bdd1f819428c2e09206d1adad6cb664c156a03cbadc5"
    sha256 cellar: :any,                 ventura:       "6e56ccd449c5f69f9576e6fab8c5f1e1fa7ed21b24260b746f09e1161c92c74e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a23ba251fb5ce78dd0bba0e7a3385763b56590a43d137c7256d8c3446b4d2e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e185a767dad8e2b89c3f23c98fbe6c6ac63c3657dc75dd29e63474d3a9c2bb05"
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
