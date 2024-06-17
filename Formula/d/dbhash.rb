class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2024/sqlite-src-3460000.zip"
  version "3.46.0"
  sha256 "070362109beb6899f65797571b98b8824c8f437f5b2926f88ee068d98ef368ec"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4a561428b21f555efd621d16804840ba018c09379a8311eead09fb681bf0139"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6563b441199c5c5e409cb6ed213a7e6c5c84293f5f8b933d41e6a0ee8f51fd82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c33cc03ed1368274e595d69eb2639e8f4b79ea5a00ba20b07b8d663e93681370"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0f0c5a0fef7b079dc5c21122a5056b64f6e8e2bb9437b5847e98c3348d94eb1"
    sha256 cellar: :any_skip_relocation, ventura:        "8e078742ef364ead4ccbea9ace753e403570044f9f476f0fe18cafc0d8f5742d"
    sha256 cellar: :any_skip_relocation, monterey:       "5029c95c4a7d164c22c6c6dc31d1b8d2955fb401677ce4560b412bfd508c0b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "152d09c187ce77a66f7daa89420b6bfb405057839338b87080d7326e35c75c8f"
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
