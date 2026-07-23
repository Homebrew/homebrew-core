class PostgresqlHll < Formula
  desc "PostgreSQL extension adding HyperLogLog data structures as a native data type"
  homepage "https://github.com/citusdata/postgresql-hll"
  url "https://github.com/citusdata/postgresql-hll/archive/refs/tags/v2.21.tar.gz"
  sha256 "808de7603e6f954690b7f1a4514f264ce0557f8c4bb9a0e8c0ba0249df4098ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d976ab79f3c4a3e76c076595e7fbe27a9b569feb4038ec8f5b9ecc6f1ff1b2bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4944479c33930ec01cc3acf769af2d6c43efe2cbb9683302c391f4f029d00545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e75fe6ce1773d2a412b055d8c6db68aae2a258f357242e0cdf1ca4c6cf29c7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ca3ad63351e33fae0bf5feaf84cc94846b4bac2d4d3fc33cf12947f79214dad"
    sha256 cellar: :any,                 arm64_linux:   "61fdcf4b1d383cba248b587b0a2be070783d190397273afdcd86edba2b3039f6"
    sha256 cellar: :any,                 x86_64_linux:  "561466d0e9a1c2c60eee2c7dac9051726ac7e3fafb1a1ddd9174c04dfd4eabc3"
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
      (datadir/"postgresql.conf").write <<~CONF, mode: "a+"
        port = #{port}
      CONF
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION hll;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
