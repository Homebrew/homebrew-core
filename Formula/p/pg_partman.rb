class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.4.2.tar.gz"
  sha256 "499734eb80feb23bed4ece1f8e47985912118b8b2350db1e16eff5f7f7a92109"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "245fc4de5c9d68efd8a689e81533f471f51db24704bb0aa9ebbc44a2860dbc47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "187cfe378e3fc3c9db70de7b393a0dd59f45e66d2bbed0302938c0e3a0eeb5c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3637fc50dde94bc66072816d89c6346f1e7d332c97f9ba72da8ab8a9411b260e"
    sha256 cellar: :any_skip_relocation, sonoma:        "168a0212f5cc747f5ef17150e6fc16f9d7b09b24b6acc7f5da7cc684d122f16a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49fb1a09ec317a502fd2a6b81e36946c60f71c0a071898c8ff57adf4ff447181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "175dc7560ddb9efd12b600037b692367a7f80d8771451c6328d1ae8b9a90f52e"
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
