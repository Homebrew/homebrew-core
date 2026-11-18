class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "03671eb27a0dc0056a3eacf1435c0e2651dfb4d32d235fb3075e066106f68a9b"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10aa32493f04ae3a5e17772ca5f8c03c3b6381ddb3a6693ea20eea73cc2dbdda"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd0409cb77d81083bedc9fbd5996a2ae1f86688a1f3c9edcb618ffa31f9ee47c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b4dbcdddfb0e876a59c0631f17a8010594c5309631c847049343e303ee87b77"
    sha256 cellar: :any,                 arm64_linux:       "dc229661470100884247915cd1e08dfbafbe99a47393bcb5ceb1ebf11b893c20"
    sha256 cellar: :any,                 x86_64_linux:      "60fe0c47826ed154295d5a02acc84d4b566ea25959fa3713eea8ba669014386b"
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
        unix_socket_directories = '#{testpath}'
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-h", testpath, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_partman\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
