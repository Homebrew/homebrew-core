class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3390200.zip"
  version "3.39.2"
  sha256 "e933d77000f45f3fbc8605f0050586a3013505a8de9b44032bd00ed72f1586f0"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "256e24913ebf38cd3460df792f26ac8ba6fe984470470828c6c6c527b1dc8c69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbcd45526a7ec4da2e74d47754c8e3dd697dd4a23d393bc9330c7ac4ac438de1"
    sha256 cellar: :any_skip_relocation, monterey:       "8c23249e5f3eddc896e23d5f86f0b99bb7337faac5af43d0b0003cb6d566a168"
    sha256 cellar: :any_skip_relocation, big_sur:        "350f1867f64421e2d4d8c064af3c498ac4981860f820b812b54a8c8b841899cc"
    sha256 cellar: :any_skip_relocation, catalina:       "9d3b764e8086434de2bf1cb1deb0f6632e9a57f2a91d3fa9327e050c6e834f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5867ad902761b6524bfb8bdfe3b2af256f8bad26723601c768348affa0bf17e7"
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
