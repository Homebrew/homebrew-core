class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.2.4.tar.gz"
  sha256 "462464d83389ef20256b982960646a1572341c0beb09eeff32b4a69f04e31b76"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc8d0101a41b8462c808e3b89ced8cf4c35abd2859da258810f45c7cc3d08eab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbb25523f90c489a1d3e960c72a5e25e2015203f076b422979105d4237548fa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da418435f548516e2c08d7152618cba4944c05ea97e7a6caf885d392367d6b1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff364c6122dd2f76874efa3993473d44c1875a9af05f87ac2b6162e0d3c3081"
    sha256 cellar: :any_skip_relocation, ventura:       "d354534be1f5892af69af5ad223d00864f39f49a1a05a161a45c32440f51bb87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "514b8f6796d0853c9dee95b01cae31d554351c999f1ebbc989553d0572fe833a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35d4cb1858223e0a1b0badd91bc8d83393da2fcd30d9609bef6285d8fe5fef3c"
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
      system "make", "install", "bindir=#{bin}",
                                "docdir=#{doc}",
                                "datadir=#{share/postgresql.name}",
                                "pkglibdir=#{lib/postgresql.name}"
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

        shared_preload_libraries = 'pg_partman_bgw'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_partman\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
