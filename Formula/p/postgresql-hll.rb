class PostgresqlHll < Formula
  desc "PostgreSQL extension adding HyperLogLog data structures as a native data type"
  homepage "https://github.com/citusdata/postgresql-hll"
  url "https://github.com/citusdata/postgresql-hll/archive/refs/tags/v2.18.tar.gz"
  sha256 "e2f55a6f4c4ab95ee4f1b4a2b73280258c5136b161fe9d059559556079694f0e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27480a860a6ad43655bbc46261a3802ea26252038b3c0ada7900d7727654248d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c452476e1fa061eff0b1e1ed08ded91385d0ea266b47173ecac203e009ddcc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7eff2df8ade96abbf8b6ea92b187994a875ef21491f57628b67b3e17524a896b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef85b1da74c48d8c1338dd3ba819f728d3c10ff0e2eb9df0144b684741bdcd55"
    sha256 cellar: :any_skip_relocation, ventura:       "f02c71f284135ed072743b270584d958183d8951c85faa42472dc0c602748b5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01e309e288fe1c16b2b47e4ec6ea57bc17da8d41bda3f49bbd869ef6aa62fd16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87c9b558987de3f251c0339c3427bf6e0c8172b887a697048b13b7cb0710e4de"
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
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION hll;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
