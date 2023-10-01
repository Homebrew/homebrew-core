class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3430100.zip"
  version "3.43.1"
  sha256 "22e9c2ef49fe6f8a2dbc93c4d3dce09c6d6a4f563de52b0a8171ad49a8c72917"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4f307e01428d3d1e5ab9e253cbad4b2a44504cee5f49ab345529fa94ed47732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef0c30f6b59d9740a340fbc2ea779c5906834ed597d9e4399ac507fe157994f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4c37eb6e375b147f5d58fe428a532c74b5d4b25c3012a92a7a10278c8783cfb"
    sha256 cellar: :any_skip_relocation, ventura:        "78d8cb97dad3fb084ac548feae1bdcf4b180f07ac7379890bafa9f252326555f"
    sha256 cellar: :any_skip_relocation, monterey:       "214570c379fd2a4c5b721e504b66875c2beeb5f8306693748458589403cbf87c"
    sha256 cellar: :any_skip_relocation, big_sur:        "802ed03c140c852ae0d68d3311f1789e1a4ba7e73550e50e7f4605c462782eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17eceaf7be184dcd701867673effa3152e7d7c5683353f796fb028e6a27fd18f"
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
