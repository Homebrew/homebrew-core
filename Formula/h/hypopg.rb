class Hypopg < Formula
  desc "Hypothetical Indexes for PostgreSQL"
  homepage "https://github.com/HypoPG/hypopg"
  url "https://github.com/HypoPG/hypopg/archive/refs/tags/1.4.1.tar.gz"
  sha256 "9afe6357fd389d8d33fad81703038ce520b09275ec00153c6c89282bcdedd6bc"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10b284849ebe8618fcd22cf24d8c7f738a6c8eebbfc43985a507678933d7cb99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5af96aaf0761e90723a994ecd9513d41771f9b29322d83d9ed59e5333d75a29d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "336b887e0c2c5cd91097071f09d67bd9d9de7524015e1496e70866c63b1e4d8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "102e97902b5026c63764d4e82c30aebe724f41d73d8bec88c6d3910a49acfb32"
    sha256 cellar: :any_skip_relocation, ventura:       "7fa60d1d35db14d12c9c77a9ada287f3b89bf9126047a85fde1a77d4567f794e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b24987307d13aef5c00b76fe88a171c97037c9e7a40abd84873066479e2bdb2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c86012c904916b59941015fa5f90726c1b968edd014214b52a7c0e3fe13095d8"
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
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION hypopg;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
