class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v4.7.1.tar.gz"
  sha256 "185821d4fbe2d966b6558203748c3479dcf51e9e19670ba5886844be11a3dc00"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4946e344db4e7035911354debff5fee4dc1ad3c5cc9dcd3ee6fc8d6694448642"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ffb00e226a7af463cd1d3caeccbf8c1da1c01a94d433cb38184555bed023e0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d59a59133630110c1e25489bfdb54f1052a8defaa0b809c142429c99c96dd1e1"
    sha256 cellar: :any_skip_relocation, ventura:        "d495d97cbb6b858d95a210dd9118a30a3220da752aee45fb1668fef342ac8ded"
    sha256 cellar: :any_skip_relocation, monterey:       "e56f79c0b80b6d7b0a920532be1848df47026cb5be456878b572dfe241494c5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e70ee17c0dae3c36bd89d803b184cccfa969c7030cf016715e5a5c4cd2a8139e"
    sha256 cellar: :any_skip_relocation, catalina:       "e29961f199243162f8eb9cf584080184defa511479c55aba5c144f4d7b12e0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20b7eec0a9714179f60df5db36048b8551f42a1c9b2f7b9289b5c3a55342c59d"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    (lib/postgresql.name).install "src/pg_partman_bgw.so"
    (share/postgresql.name/"extension").install "pg_partman.control"
    (share/postgresql.name/"extension").install Dir["sql/pg_partman--*.sql"]
    (share/postgresql.name/"extension").install Dir["updates/pg_partman--*.sql"]
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_partman_bgw'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_partman\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
