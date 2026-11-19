class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "03671eb27a0dc0056a3eacf1435c0e2651dfb4d32d235fb3075e066106f68a9b"
  license "PostgreSQL"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "328d5ec2bbc08b85120f17786ff7c25940017a01679262b42ebf4d8a6a94356c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e88e9c496e5599357cb7be11765f66e909997aadc6cfa4510a229a91cc93ca1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28c43fe6246433804f677034bbab7bba14ebc19aa23d8ccff2008fef71ebb91f"
    sha256 cellar: :any,                 arm64_linux:       "d941b2b985b66b94887e561260c05c6f2032c83ef26d26233de357ce1a958b44"
    sha256 cellar: :any,                 x86_64_linux:      "10dd8d1e3f7e6eb2ffa2dd8e1b5df4df0e9372dfcbfb0e0404a3cd24d36f522f"
  end

  depends_on "postgresql@18" => [:build, :test]
  depends_on "postgresql@19" => [:build, :test]

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
