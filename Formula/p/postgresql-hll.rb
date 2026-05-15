class PostgresqlHll < Formula
  desc "PostgreSQL extension adding HyperLogLog data structures as a native data type"
  homepage "https://github.com/citusdata/postgresql-hll"
  url "https://github.com/citusdata/postgresql-hll/archive/refs/tags/v2.19.tar.gz"
  sha256 "d63d56522145f2d737e0d056c9cfdfe3e8b61008c12ca4c45bde7d9b942f9c46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17db595caa269ee31d2b540fa9e441019ffac25b4062690824f5f726dcaa992d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e235a1f63bb5da5ac21e425ca4e051bf99a24eb6986e62eb8823e3dc010763e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69c8dad6e719c444fd0fea42b7def97b3503aa12875eca051f8488ada44d22c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "214e7844d487ea202d54ebf8ae65677d980b8e371b26d29f067eb5f069a2a6d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c34d132dd0e9543d3c14e707bf16fc28c36a41c51f81ff9bf8f8f0b6f9ce51c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5e546957897b0dcb512910e16d9a5667e10f2bb1bc8d672eae77a21d49ee289"
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
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION hll;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
