class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "6f88a5cbdde31666f4b6c1a6b75c51dcbeffe58f9a7d2b26e502d5a6e5e14d44"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96080fc206d9682155d4782bf4f0311644c18084f6ef6a7d588f030f5cec5061"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b83fd02b6da78e90bf6bd4ebef312ef9db3bae69eef2b4fcc4868e8cf5b26a70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "658727f9f7cc8c287da5d8acd4f8312d3b2a6127403f867ac41d4663d3858292"
    sha256 cellar: :any_skip_relocation, sonoma:        "289a9da37677046d4bdb29657e909cd55946a62ac545b7afd798758e1b92c7f1"
    sha256 cellar: :any,                 arm64_linux:   "20d4d67095018e916c10f7eb60be563a4a4b6dedc2fe549c702c1952ebfbc80b"
    sha256 cellar: :any,                 x86_64_linux:  "1c0ecb3e557aa3e79bc931d351d84ffa32ccd317f92c190228b3b515a271b9c3"
  end

  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

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
