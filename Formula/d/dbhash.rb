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
    sha256 cellar: :any, arm64_golden_gate: "b77ad95bc82d8047af615bf4864f4daaa46925aae4991a17e75b0cd994b25343"
    sha256 cellar: :any, arm64_tahoe:       "92f3e342efd9399e89cf6d2c97c09cd74450986755ebd34b1eb51550967ba35a"
    sha256 cellar: :any, arm64_sequoia:     "375b21f302fc65751bb0f570a0e4be4118945e4a8794cafc0db14c1feacd5087"
    sha256 cellar: :any, arm64_linux:       "e576e58232a17cf725af4cb8f73b1e2c331a61413124129881b6fd5a78d38a66"
    sha256 cellar: :any, x86_64_linux:      "c2aa4544a7ae0719e3a9c603497c339af352b4653195324e7f83314640d8fff2"
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
