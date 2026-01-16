class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2026/sqlite-src-3510200.zip"
  version "3.51.2"
  sha256 "85110f762d5079414d99dd5d7917bc3ff7e05876e6ccbd13d8496a3817f20829"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6234b2fb20c777be04ae034624991bb0c222f1ee1680c377dcb3ce17122199b7"
    sha256 cellar: :any,                 arm64_sequoia: "cc9159fcdbba1651cc43c1e65f832146900563e830380c3344598ba45379561d"
    sha256 cellar: :any,                 arm64_sonoma:  "b1b1c477cbbaf75973a479d21076b8f23a4a0dcfa9f2a95b4823d87e9dc3a720"
    sha256 cellar: :any,                 tahoe:         "e4f938c7ac1ac6f69f7e0e29edd8572495130258ad212c657ce507fba001429d"
    sha256 cellar: :any,                 sequoia:       "fe3ad197a476a2bf67f5282ee9fe564569d92620b04e7fc2822bf5627000ffc9"
    sha256 cellar: :any,                 sonoma:        "d227cb0625c8bd0673982d0d707bcecf32755c66f3099cfc19b92627a9be4b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f5398dcbb7c65aac7c22a4a63ba506705a1503b6744de182f54fb14f9e78985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7903b6998fc34b8a28d68763c84f400d8e85408e6a025d06fdf967d5a07200"
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
