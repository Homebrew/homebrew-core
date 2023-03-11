class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3410100.zip"
  version "3.41.1"
  sha256 "db929012f9009e7f07960e7f017e832d8789a29f4b203071b4fd79229e7d7a20"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f2373ed9b0c83a637e27f7ec30a6df520f105bfc9ed72ea6a2be7424ec4a499"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4a8eef3e21d7a6f17d8175c2591cde22a9bca1dfb2b2e3f3c371f4a4c3c4a84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c872c1b12cefdaf2b4a2555785fcafb9e207e480364f037e12c379d8a8fa533"
    sha256 cellar: :any_skip_relocation, ventura:        "0d77bbcba730320595e84f2c344c7e83756f5d91ecb9594d921c49c4d6f0a462"
    sha256 cellar: :any_skip_relocation, monterey:       "11b1bcf78a5667b746ba77e197b5165610ff055af4f99a0ca3976980f76c066e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8389d36f5fbfee271cad21849b629256f0c9405bb91d02ee4514f89a4cc9e7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead69fbd9443b3a581fd5f457950be295de284ce1dd6c991f915e9ccb0e36d1d"
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
