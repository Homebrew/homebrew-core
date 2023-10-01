class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v4.7.4.tar.gz"
  sha256 "e81e9b4edbd36490be6389e2a593cac9a55b1694ba84f8fd4b08df5b17d6233e"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73b11b7a1e1258bcb463fe36863e6c276739952250c492fba3628ab9cdbe4080"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dc19da93cb2fa7f1bb168f52456a2d2410ec01a8b686f0f1d4ec2e5f90d877e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "599763c1eb5ef88cf5a42c7c0b4d12bdc87ee8f93c3e39b37d3036a98917f501"
    sha256 cellar: :any_skip_relocation, ventura:        "9a3854be8ee43736608469f7e7913b403b40ca9b11b24be7a8eeac0661227368"
    sha256 cellar: :any_skip_relocation, monterey:       "3f7ba9cde4ee1693b3d6db89888dfca753327a91e5140b8cf813860b896fb5ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "be5abc5ebc570d9c4fa01327ebf15c721d9b18666e800389c635d8f2cbd6e7b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f17ce22ba0ff4f9204f4a53020fc3aea3383e67432d69ed6d932e8dad4091a7"
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
