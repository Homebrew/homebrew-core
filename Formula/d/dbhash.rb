class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2024/sqlite-src-3450200.zip"
  version "3.45.2"
  sha256 "4a45a3577cc8af683c4bd4c6e81a7c782c5b7d5daa06175ea2cb971ca71691b1"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db2c55520905614b6569e57db5511002d54a2d88cfdb2358c83bbd82a0745b26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2480346436f610b673af0dcf7690faf737938a1fe810b546b59a74046d269ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d9eea5fd853cb9481cbe1f841fc3b9f86af3a3023f5a5fd982640709ff39d5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6cf4a090f86034500a200c54679de84bb21316ebdcadb7e6b3251bd7d16052d"
    sha256 cellar: :any_skip_relocation, ventura:        "da5b541419f1a8aa97057c4b2aa2622032594b57158de5d6e8862578226920bc"
    sha256 cellar: :any_skip_relocation, monterey:       "0efae6c9cb9fe978ca3cee4f0aad482f33837139ac8f9316c559f66607e6eb0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ef43e886867c701bc6e3b9d2339f482750431405912f6e3e706400c49e701f6"
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
