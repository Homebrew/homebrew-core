class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v4.7.3.tar.gz"
  sha256 "f6b376da1ddfbf9482b3a10f3e2bb414e546e67bec32acca5a9eb7d39719036e"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "869fb42b1ac9a6d917259110801f02a82efcfca36b410f54a2c50fadb805ab65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dac312d8723156e49f4869f527cb633b843c207352b25fa927ce08ee13439e78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88c6dff46f92163128a10bcfe5bd3207f7244e841e7c7f54442b0bb06ecef88c"
    sha256 cellar: :any_skip_relocation, ventura:        "45b4fcb754025acb9eb6ee056dcbee64d5eb88cf83a901b6f8d31bd0b5839e04"
    sha256 cellar: :any_skip_relocation, monterey:       "d6beea5f6fac3a953e706bb1d83f18058b43b0fb2ebefc8e6b2bb54f9d5594c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf345bc7792b4a246a241a95e3420a3571f839e0a4364ae6885247908732ca23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "877472dc45361b9e0caa7a031b8acd78a03e6b20c575953b78df48f6c490949c"
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
