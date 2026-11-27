class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "cac0b10c360f05b2d521200105ba3697e773d4cd3731f5a915a7e37ebe0bea85"
  license "PostgreSQL"
  revision 1

  bottle do
    manifest_sha256 "c8cc0ba1f1b85d973603ffdd200db29dd15ebfee4d1f4f9e16b7ad357587f62f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5731617b09cbaa103c5d929fbf4d30b2270ef0d5fe6c4c09327bbae6b94b8075"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8de9c8aa037c813d939dfe761e1ab28e7d6b20b98a71eb951c6306031e110cff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5f16ed6c60c703280a2760e2c5862a34f469b758c8941bd4c4f4f1dcb3ad3e4"
    sha256 cellar: :any,                 arm64_linux:       "68fdbd03e5533bf39bb13e7d6f10b4fa6cf9315628c9e994ef8d60e22a4f5098"
    sha256 cellar: :any,                 x86_64_linux:      "0cbf08566402266b3cdde87c5a2961d2348d02439373df59a543a36df1ce65d0"
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
