class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2025/sqlite-src-3500000.zip"
  version "3.50.0"
  sha256 "af673f28f69b572b49bb1558c4f191fd66e31acb949468ad2b01b2b6ed8043a2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "022061864312b3ef9002254a668e33027e36d6fd13547929b1a2513f19c1514f"
    sha256 cellar: :any,                 arm64_sonoma:  "1138e792e57800f81948491a820ffdb5c1674b0b783062fb690d8cbab863dfdb"
    sha256 cellar: :any,                 arm64_ventura: "60a48091a3024b4ae5145086c8bb1360cec5f888d88cc3f46adbf7e9c35131da"
    sha256 cellar: :any,                 sequoia:       "32fa6d137ad56b0a69468d9498fcb9eb583f57ac7d17ce7a01c8fcb9f20f1598"
    sha256 cellar: :any,                 sonoma:        "01c4118cc4a74ffcf842275b993e2770415a503669d0ddbf025d1b6149b80125"
    sha256 cellar: :any,                 ventura:       "54f6667832e75f36f4106bc8cc9f065c42d6a97b33e50bedb635209723b62228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1717ea2dbc674939ae64f4a9fea34098988be280fb7b224fdfb9ac788944f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "773c9edd59cb2dc02b92ed493024d3abc5616e8926cb4a53749e1a906f4efd76"
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
