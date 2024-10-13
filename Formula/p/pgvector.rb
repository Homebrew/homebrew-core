class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "0341edf89b1924ae0d552f617e14fb7f8867c0194ed775bcc44fa40288642583"
  license "PostgreSQL"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c15fe20140648ded883016f6edcf606926b1654ecb2b82b73e035c0dfc7bf50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe198adaaa6588303ae2032c61cf8dd535ad06e9860780335dfacd4396ed19a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c7f23fe6998cf78b81613cbe4c0378fae3ce4ef486e10c3bf7eed6323d6b337"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9f6ed112975cb8a21208609fa5773c37bb74ca6ea112159b4a7f33ca2238c18"
    sha256 cellar: :any_skip_relocation, ventura:       "b8058a3a989357e9e6ac1bd7784b6bd77f107c960d088da487e716cf1dee2ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5020858a996ba215f18234bc25e7552edae986911cfe0206980c5c8d0affc45"
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
