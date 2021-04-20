class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2021/sqlite-src-3350500.zip"
  version "3.35.5"
  sha256 "f4beeca5595c33ab5031a920d9c9fd65fe693bad2b16320c3a6a6950e66d3b11"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "192459af55fea298ab699637dac1d8ba6ff29bfb7c419707e971b14f794aa4b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c3795a82d8267b8d8fe7c829d680f739819dd4dfa25179fa4c8ffcac65b9ffc"
    sha256 cellar: :any_skip_relocation, catalina:      "5016115b60aac4dce47d73d8407f215a109a35c42360d5a5322ff193bb960a5e"
    sha256 cellar: :any_skip_relocation, mojave:        "6adc51b47cc9bbe81adc4693f48bc24699459ec1e036253ce54ab1200ceeb288"
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
