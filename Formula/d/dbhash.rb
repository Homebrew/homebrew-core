class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2026/sqlite-src-3540100.zip"
  version "3.54.1"
  sha256 "387e7f6cad4797b17848c07d453dc6606917bb356a6cfe5a3abafd38c240c71b"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c990a1919fd832cc83cf43a8a7556d0b90e095fa8e3f1ecf0a84c0182cdcd9da"
    sha256 cellar: :any, arm64_tahoe:       "41476d5c27ab7ef028dca51329eae35457d2142e53b3b0f75ec95e4976afc848"
    sha256 cellar: :any, arm64_sequoia:     "55b4cc15061fc531b0adafdd2966e6180b7dc6ecf4a79481d89480f311aed930"
    sha256 cellar: :any, arm64_linux:       "e43c7616bc28867722d764a3d4a7efcc6f74b344053692b947fd15176c18a9a3"
    sha256 cellar: :any, x86_64_linux:      "43856b93646cdb800ad70f5c75650b4515592ffd7548fe3fbc2070bed2d450ab"
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
