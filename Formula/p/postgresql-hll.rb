class PostgresqlHll < Formula
  desc "PostgreSQL extension adding HyperLogLog data structures as a native data type"
  homepage "https://github.com/citusdata/postgresql-hll"
  url "https://github.com/citusdata/postgresql-hll/archive/refs/tags/v2.21.tar.gz"
  sha256 "808de7603e6f954690b7f1a4514f264ce0557f8c4bb9a0e8c0ba0249df4098ce"
  license "Apache-2.0"
  revision 1

  bottle do
    manifest_sha256 "efd76a4f947978430fa4914c4fd453d736e4c88f59e4de458fa41893fb7a7c8d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e20080fbf12a371589beb62e1d87817cadef6f304f93ce35837d39c2c2584fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e15536b951cd3ecbf312d059f2df90671e64bd71c5df93421b02e8433f637c6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c821165fe5515c612f1d3aae9588897f95d2cdecb5ee1bfe71b88cb5fb857cc9"
    sha256 cellar: :any,                 arm64_linux:       "9d38de701e28590e7a5fc9eb8aee9ebef7e14fa80a06b0c64d4e36a8ad5351e6"
    sha256 cellar: :any,                 x86_64_linux:      "77d6dde04122e326201d057092ed916fa37ce713a6fa6a208da5458e420f354c"
  end

  depends_on "postgresql@18" => [:build, :test]
  depends_on "postgresql@19" => [:build, :test]

  def postgresqls
    deps(/\Apostgresql@/).map(&:to_formula).sort_by(&:version)
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
      system "make"
      system "make", "install", "pkglibdir=#{lib}/#{postgresql.name}",
                                "datadir=#{share}/#{postgresql.name}",
                                "pkgincludedir=#{include}/#{postgresql.name}"
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
      (datadir/"postgresql.conf").write <<~CONF, mode: "a+"
        port = #{port}
        unix_socket_directories = '#{testpath}'
      CONF
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-h", testpath, "-p", port.to_s, "-c", "CREATE EXTENSION hll;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
