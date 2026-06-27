class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "dc080c511a6354a1628eb19f9bc8e77ce880dde16c889744a6814c8c0006e36c"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b2c532d9f719244dd76477694f71f2a03da67fc573a7f8564f847bb3f2e4fbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8128e7e831182bf851c815cb5a7384c984b8529081ba9e600d6985001a640d61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a65ac6d3b3a0ed694ca363124eafe9e52b89c0fc67c9366e1335d4ec98ff31c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e4cb525195816cca54226536931c852d9ee4c2945432ca362098d45304961e0"
    sha256 cellar: :any,                 arm64_linux:   "1264a108af7737449d0f73485ef866212e35c75133caa6b8ba1f1602fb96fa7c"
    sha256 cellar: :any,                 x86_64_linux:  "424ae525194722ad39af83e843dd9361807a4f2258821c3d8566408456a0db14"
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
