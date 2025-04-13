class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "867a2c328d4928a5a9d6f052cd3bc78c7d60228a9b914ad32aa3db88e9de27b0"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0ea074a0dd35acc1957c1f2f6d90df297a16d7e47f94368b85e3a309e9540fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01a8036c0a03daa290fca07e915e406356fd36cdbd084117e9246d772955b438"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d0edb94eda91ef957b4497c0173c33579f860843d6c105d5668f1ceb86d11a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9e229a72dbc9e7b8e4587389823caa307fc1ee0f2338e45140a49e4ece5c4eb"
    sha256 cellar: :any_skip_relocation, ventura:       "21e40f77e8afca2fae9303cc45216b53ec79d48ebc3f8d7cd79b2fa8a22aa6ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bd92df44356b7200defec0029fc583550a1121a5ceddc0e8a0fab98a42571e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7765039d7b20e78006e2ff2c3b197185a9c80e8b930a384b8e5feeb88eaf3afa"
  end

  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
      system "make"
      system "make", "install", "pkglibdir=#{lib/postgresql.name}",
                                "datadir=#{share/postgresql.name}",
                                "pkgincludedir=#{include/postgresql.name}"
      system "make", "clean"
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
