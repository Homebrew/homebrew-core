class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2026/sqlite-src-3530300.zip"
  version "3.53.3"
  sha256 "bb80bf8a3bffc19241ce8aba5a4bc74e9c3980013cb0b5f0f0976a99516942af"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4c308e5b502230fe9874d4fc2d441cdbc3218e10a05116768071efac5da7d4a2"
    sha256 cellar: :any, arm64_sequoia: "f1f76c438b084a6c05c45a9559268a1e7cc5756d520ab78b8c006ef83e663f54"
    sha256 cellar: :any, arm64_sonoma:  "e39f59c76d679a4abf306c3657a9a9dc4ec24bcfd45fa2521de085e9fab3212d"
    sha256 cellar: :any, tahoe:         "a93b000096c778f3b64b1121e915fa6cf97e6ab5c95ac1a77a993087db6b41c1"
    sha256 cellar: :any, sequoia:       "5f6ec3b18f4fafd65c036c85283f27b929c3834037e14f11257222c2554a7157"
    sha256 cellar: :any, sonoma:        "e684d0a69237b1a426b7ff5ae7a974e6068e00c022b68e2d4b38d2f9b520741f"
    sha256 cellar: :any, arm64_linux:   "ea2e771e138d09cad4b1d49945b3152d7cf8a4545de317ed5fc0533bdf2eaaeb"
    sha256 cellar: :any, x86_64_linux:  "2a4fcb4f837909bfa912502c73e8b3d1e5a0e920a15163b75799b9b4284b475b"
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
