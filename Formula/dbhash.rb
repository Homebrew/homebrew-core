class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3380200.zip"
  version "3.38.2"
  sha256 "c7c0f070a338c92eb08805905c05f254fa46d1c4dda3548a02474f6fb567329a"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ced1dc866477b5ade3812bd46ee3e9890d4c1702aa85e925aa74343285770799"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d61ea13745bb956115727270a9409574534cc08532fa5f2826475aa957e4747d"
    sha256 cellar: :any_skip_relocation, monterey:       "376852a074d6a7d9aad40a501ece7bd61d32dd4c45079cfeacda783780faded1"
    sha256 cellar: :any_skip_relocation, big_sur:        "10ec8707f4ede909cb8ba96da7b48258f495016c43bbb57ab6a127e69bcc3017"
    sha256 cellar: :any_skip_relocation, catalina:       "06c515a706d93e5b6b48ccb3f5e6bd03f2174fbfb6ca9363110c319388a03fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6f01fc2312ffc05a838df425790a8158b95e6bf0517edb4ef48f602a8c4a18f"
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
