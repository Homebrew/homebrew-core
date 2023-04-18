class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/v0.4.1.tar.gz"
  sha256 "12dc08c33165a2f14d97d1c153d6ec3dc0c8d1b8c53ac3ba8b44517e8795444c"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57b81bfc6d79372eba894ea7c70b9b05a91f533aeb5c2abfcf3fec3e2b6e4bed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd0832ad1017b5fe068d6ff714fb6ec944f475f75c8dee59a94a3cda09eb379e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8aa577a8255c96195151a8cb2f137dc4ff5d7712392926a3c78c8ed06a9343a"
    sha256 cellar: :any_skip_relocation, ventura:        "c73d91ea5f8c8edbea6dc98dcfbd90308ce07502e62420c478c459a56c82bd20"
    sha256 cellar: :any_skip_relocation, monterey:       "cb28a65a3066fb5d69aa2d20f0e2ee65b245232d6b949621072050c26ad204c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e24195087f6f99ac507bf24323ed02f957353f6fcb26d5c6c5dd96d9b7330274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "227d2b857e782195bfe5bf8ce90e27ac78e17e2ddff20f829f56cbdae12e02e8"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    (lib/postgresql.name).install "vector.so"
    (share/postgresql.name/"extension").install "vector.control"
    (share/postgresql.name/"extension").install Dir["sql/vector--*.sql"]
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
