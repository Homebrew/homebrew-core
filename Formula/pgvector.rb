class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/v0.4.2.tar.gz"
  sha256 "6ffdd35d2882d18e1d6e68d042105f2c9b8b1e559f1ef8424db1e05aead7cc99"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25f26043bfac8c8b169d88a5a82d34327b0b8d7f8d6338413dacbe8340377d03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a97cc7c90e748087db8f2784fc912bf275b211de346a1f309d294b6aa9a7ab8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50dcc8053ad77b59e06b40c3d03fa7bc76fa06005047470dbc7b922c7332eb1f"
    sha256 cellar: :any_skip_relocation, ventura:        "1794b25bca9a3da1057497f0a335b6c335ecf245b0b7990811b5c8906aff783c"
    sha256 cellar: :any_skip_relocation, monterey:       "56ea53e04b4d568400e25a89c5e18fecf637013a0ed36cb0b67a3998e1701ee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cb30af9b1d3a5fbef9dcb1e52bfbe5f2a3ab1116e923275c3f91f86ef54dd62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f995f6831f700468cf7722109985af770b45062c7d5bf8861cba0edeec4fce5"
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
