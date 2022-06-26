class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v4.6.2.tar.gz"
  sha256 "81ec4371985fd2f95ce4321b63371c0a308d476e57e6a4b7a5e23d73a5e4b218"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ec89b592aaa7de8280981ee2905403f7a49420b65bbe23ee78d58711a8b7ecc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dcec4630d5226b3ce3b8437245112e6651a1ff333314fd9f990020d1c1936ea"
    sha256 cellar: :any_skip_relocation, monterey:       "fd37231534dc02fda59b830b708be8e4e030aa0bbf56d800ac34df360d4b6a48"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb5bf4643b09e896e016ba3cb00239cd28e7fc063b9d7cc97b6f5c295af9c264"
    sha256 cellar: :any_skip_relocation, catalina:       "6b5156032cfdffd9ace4109e6939dabfeb2310d810bef356506713c4739840ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9e8c6d9ac5d32c6fa8c366d9bc2d2f487e26d748a7ee345403edcb1a41cfb4d"
  end

  depends_on "postgresql"

  def install
    system "make"
    (prefix/"lib/postgresql").install "src/pg_partman_bgw.so"
    (prefix/"share/postgresql/extension").install "pg_partman.control"
    (prefix/"share/postgresql/extension").install Dir["sql/pg_partman--*.sql"]
    (prefix/"share/postgresql/extension").install Dir["updates/pg_partman--*.sql"]
  end

  test do
    # Testing steps:
    # - create new temporary postgres database
    system "pg_ctl", "initdb", "-D", testpath/"test"

    port = free_port
    # - enable pg_partman in temporary database
    (testpath/"test/postgresql.conf").write("\nshared_preload_libraries = 'pg_partman_bgw'\n", mode: "a+")
    (testpath/"test/postgresql.conf").write("\nport = #{port}\n", mode: "a+")

    # - restart temporary postgres
    system "pg_ctl", "start", "-D", testpath/"test", "-l", testpath/"log"

    # - create extension in temp database
    system "psql", "-p", port.to_s,
           "-c", "CREATE SCHEMA partman; CREATE EXTENSION pg_partman SCHEMA partman;", "postgres"

    # - shutdown temp postgres
    system "pg_ctl", "stop", "-D", testpath/"test"
  end
end
