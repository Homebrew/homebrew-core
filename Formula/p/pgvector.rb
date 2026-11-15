class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "cac0b10c360f05b2d521200105ba3697e773d4cd3731f5a915a7e37ebe0bea85"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9363a3a6e4344d4c2780308b0938556ae18c937e398798117627912fd90d651"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "326bc17440a773b75b054d83d7905b46b370b1a1b6543fff077186b5a632253b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01dc0c82b633a46b651ca07ef6f46e2ebee35d73bc690163ac58b0514fc3e0d1"
    sha256 cellar: :any,                 arm64_linux:       "069cd51a35f872f1baa4e4cc14e11f37732f92e0c7bad8e95b75358f6316d333"
    sha256 cellar: :any,                 x86_64_linux:      "c19b2990a748acfd11ece70fff7024b52baa1a27e72de3958467a3d97810b044"
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
        unix_socket_directories = '#{testpath}'
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-h", testpath, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
