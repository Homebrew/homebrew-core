class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3420000.zip"
  version "3.42.0"
  sha256 "38ca56a317be37fb00bd92bc280d9b9209bd4008b297d483c41ec1f6079bfb6d"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97e299f95f672c0bcc64592cb156da5d7a1a61e7c3eaa1cf216aaab350bb0fb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1369d0255fabfcd24a5a2995735755615bc8cee92adb394ca98c82ba5839378c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cb6d6c0473765280634f4dae8449d452f91bd547e00b55fc17d591db0428fde"
    sha256 cellar: :any_skip_relocation, ventura:        "bb5f9004ffdac465c1e77b3404147c2b3f5f24d7255354fbcac405578c33e05d"
    sha256 cellar: :any_skip_relocation, monterey:       "c7a53839b8377e23932d147335e8cb13e6600eafa01b20c3b62499d0d08a5a15"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5b675011a297b720d27c4fbfae89b4b24fe1e3b65a99fb985072aac3b3523a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40bdafc1b8525af0b0bade4dc48a24ce30fb4b3bb703006eec4a4f37b4e8cacc"
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
