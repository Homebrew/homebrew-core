class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "0341edf89b1924ae0d552f617e14fb7f8867c0194ed775bcc44fa40288642583"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a251bbc3992e58169aa83d7a2753c9ddbad8d0dedd65929e386e6ed2034a2305"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2360d6c6185c21e7928d24c393aebce0568a8ce3c5f5d5af40a4e84283b5bd5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56be02b9338ff682781ab0f371f5ccbf45907eab6cfc4c60eddaa140e73c2477"
    sha256 cellar: :any_skip_relocation, sonoma:         "11938beccda5271a79a663f261484d3f813f275ae82b5911ba83bdcbadf1f02c"
    sha256 cellar: :any_skip_relocation, ventura:        "45cab40694323e8e7544530a78898fa0501dd7123ac72019bbf9bcc1b7e2d1e7"
    sha256 cellar: :any_skip_relocation, monterey:       "5485765a2bc9c645504369b020049462c4c5d59350d215e89a3b840b4df70a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbff5b6c43f5d6f90446c96d65b34b26227a74a848abc9fe0ad73839cfb4121d"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
    system "make"
    system "make", "install", "pkglibdir=#{lib/postgresql.name}",
                              "datadir=#{share/postgresql.name}",
                              "pkgincludedir=#{include/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    datadir = testpath/postgresql.name
    port = free_port

    system pg_ctl, "initdb", "-D", datadir
    (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", datadir, "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
    ensure
      system pg_ctl, "stop", "-D", datadir
    end
  end
end
