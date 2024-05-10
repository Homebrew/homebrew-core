class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2024/sqlite-src-3450300.zip"
  version "3.45.3"
  sha256 "ec0c959e42cb5f1804135d0555f8ea32be6ff2048eb181bccd367c8f53f185d1"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b637a72879f607c00108c170d6adcdbff9ce6cca6a25437d4519d99b26d87eba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c953a335342ea1e318e867017abecd4a2ba8653827ed1a5e2b04f9c3706dbaa7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c15bc4717c109d8a8ee56205d15d7aeaa7bb3315b6d6a49fa562cdd199632d5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9ac1519447779ad97335d61f7a36e6a3579ccdca26dbf486c9f877d27fc56f5"
    sha256 cellar: :any_skip_relocation, ventura:        "aa7184f4e481ca356506cd2f21cdb3024c7940df3b1d864bf70bc464ed8820e0"
    sha256 cellar: :any_skip_relocation, monterey:       "7acbe4702d1276f30d520b5f03e055cd1d68b77f553de5c15b977f97a4570fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55ca4ae012eb77eb71a7adc34d667d4153176c4b4d310a602e8df4dedbe96b55"
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
