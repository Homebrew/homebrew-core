class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.2.4.tar.gz"
  sha256 "462464d83389ef20256b982960646a1572341c0beb09eeff32b4a69f04e31b76"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aa872814097e24a5251c1ff5b9c1962958f480ecb159a6ae80632bbd8be2ada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "237456de81b9e9656dd9de9e54311e51ab859cabf251db79bcd0001ca727d6f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3360bd68ca5d0297445da2ae315fe2e5d59edb5df7490550081d0f80794174b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1925b115886c4c53d4f52d18cee74d07617ee927a795eb48cac622f7948e4bf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab848f61fc5c01cf74a13c5c340412fa9cc3a8e0e00f38f101abfc46ff251c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b712bdf503c41e4fbbbcd9e7aced208586c7b52525cf6104c6fc58799b94eded"
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
