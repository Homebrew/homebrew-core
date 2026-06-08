class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2026/sqlite-src-3530200.zip"
  version "3.53.2"
  sha256 "cafff764c03f6d720968f746e2f47a986bbf12bf4c18904f1eb131c0b0b592d3"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4f6eb13f29e854d1c935b460f8d22da2e88065a2d7c2973c9d64976b32206fc2"
    sha256 cellar: :any, arm64_sequoia: "81f8143c204a37dc88f2a2b20407bbb22a7b81d71a31ae4d1038b87483cb3376"
    sha256 cellar: :any, arm64_sonoma:  "035ab7c49fb0ddfc44f8b43303cdf1e9a4f69feb79f81df2737ec9fd39a5f992"
    sha256 cellar: :any, tahoe:         "389213f82d6d80fd1073da3d19f25e18960b83c97f9ed04598de00b46e878e11"
    sha256 cellar: :any, sequoia:       "a34a528ac7ded050ffb7c4314698d280ca5bcf455af12735e5ab6f3ad9eac222"
    sha256 cellar: :any, sonoma:        "d0f4c712f5a0d7edc338d80fde96e72fc1b0afeaf0e25ee4fcb08640e49c5176"
    sha256 cellar: :any, arm64_linux:   "13ff7314d0d11c1d8da61d1f22ad380a4ea59b942362ca81230646dcb8c17f13"
    sha256 cellar: :any, x86_64_linux:  "f3bbf2ab6eba9e6bb0f92631b40a56aa7c793f5f869e71cbf78b4d3769bff3bc"
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
