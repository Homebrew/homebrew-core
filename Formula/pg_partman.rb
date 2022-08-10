class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "c5d2653a705c98e544819ed48b04c84a18953b73aa1c45a2300d00f8c6506436"
  license "PostgreSQL"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d30c2f67029fef09fc8a7c50d518a1cef89a62b42de03e5a95a832e2a724dde2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a91a6bcbdafaddcd93952f2eb55b64b99f25b5d80107ee0c1a8019af4e2d82a7"
    sha256 cellar: :any_skip_relocation, monterey:       "58816573d271ccb9cebdaa5605e12cbb55c80fae30e3d9072d2c7c78976a9e7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "600a43c52f8d030ca8cbfb852a1df9831b535a10ce0ae323ad0448bf20518f24"
    sha256 cellar: :any_skip_relocation, catalina:       "b050f9e5be1652a54cc2e6efb22112689fa315ccbbfc419e5ef73d6fb4d9c595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba38a04262870382a5bb6e986852beac780a922def9857456eafa92b43b98aa1"
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
