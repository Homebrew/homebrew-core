class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "222e7175c9afc417aa6e03e826de4a5eb2a88fd8d1e3d06321aa8dac2471c005"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "350aa7f059bfbda180a1caadae4108706a5337f4067f93a8e85d50fe203d4e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1761cb66d3b4e4a78858d225eab346cbb3572c16231ea382a7617cbfb4b5b6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "260e9e596d8e09f13f12fd5dd5f89b39062e8f3005b0a9660ccb5fbc0ef6893d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7b923f121dfda40451b2ba3f6db7fc3b27803faa8e4055a8f1c948b27c8f06e"
    sha256 cellar: :any_skip_relocation, ventura:        "f2703df6ff6667b1e25e83cbd2922edce3bb17f4986e8abdd91f091ba59daec8"
    sha256 cellar: :any_skip_relocation, monterey:       "a07314ff83b1459022031658d0fdc501a94decb869c815380c96e974db6e2ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3167d017909a68ebb1a94f01e943dea86964b8d4976051c8f888a678ebfe33cf"
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
