class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "3e3a27d7ff827295d5c55ef72f07a49062d6204b3cb0b9a048645d6db9f3cb9f"
  license "PostgreSQL"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "995615e05892a4a62213fd7248beaef88fdd345b3a386b6378f93f28e42112de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c2e05b74290971c37bb8cd1af765a95e1b9f3241cdd73373a74b125619a74da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f44f771ad70e19ef41072b2a1465ce0aa1019cd77c475d6a9583484c284eaa0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c474f3a11de006f0c84e159dc21971c5da027b0138f52d5f31689baad2afa53"
    sha256 cellar: :any_skip_relocation, ventura:       "a9ce480d5188be5afa9ab08a75c12f2fc1f6993fa948d1350b2528c9d7687128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61a6d1327005efb276aa8487952bd916293aa83a33efc96307334faa2bbfa2d9"
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
