class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "69f4019389af05dc1c9548deb8628e62878e6e207c03907f2b8af2016472cdaa"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cf8043ead096eaa3f792e14a89702ec73d0383178afe9d9c778130774800e9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "399278fcbb54591159019a4e821cc19b651dc8df6d26fa5920c5cf6e6007f4f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0cad39c6f8e5f8d289fee2b5a801bc70795f4e6b4419de5fb0ed1b6dce40f04"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd3324af174e284d6e2b2499061e744b9f259eebb3b03732abb96a38eaf1581f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13085e8a50a501137a1e19ee44d2dfcf1a186fc69aa3969bacebd5a4a58c29e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4654c76fc87533d553c91d2c5bc7f7452fbe28d54f7812f99ccb9b71833bafff"
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
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
