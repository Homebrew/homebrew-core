class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3410000.zip"
  version "3.41.0"
  sha256 "64a7638a35e86b991f0c15ae8e2830063b694b28068b8f7595358e3205a9eb66"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd1439a6812dd6073ae6ac5eb975343716178eb0cf1945ed45b3fcde09e657ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0229e127f9b2fd3d7c16e49d92c6f9e007f311bb4123c2e10aa2e1a651d780c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c83d86d9fd1b140d8072f15529f919b8459c3e2b3f30f9281d3a87b26a36b73"
    sha256 cellar: :any_skip_relocation, ventura:        "03a3536305313abfda419a0730ee200bd05637206c267009af33f7ca73230785"
    sha256 cellar: :any_skip_relocation, monterey:       "20063cc43fbdcf212827bfc8cbf8014a21c892392b01d369e4b7beb47f86d142"
    sha256 cellar: :any_skip_relocation, big_sur:        "340217fb93d89247c61181bf6960420666d62c5226eaab26988495680e455d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03d8953dc167d1dcea41038321d9a975276c738e7c9d8dffda3aacd973d0427"
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
