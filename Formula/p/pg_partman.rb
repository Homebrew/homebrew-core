class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.4.3.tar.gz"
  sha256 "c52e3b8cf80d306468f48fbdb1905e4c2574bf8362240af57aebbbf9e18c6fe2"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b20aa24f431772b40f3c469f4d2d1c41ff63d4653d5a784c6a790776623a152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9f5fe3a0f79c09b46e69d619589ae6f0feaebf2f704b0925af87078df80d860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faf2474fb09539ecd1ea6311467a788dde9a4dda4b86249c1a9e60f04bf6031d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8bbe80932384f7b87d52ca474fce6240c65b151a70b2afc1e6bedcd7a71f09a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c737e57d771637252d4c1f26503ba98f93e3473719cf3af479f527b72e892dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64eb2a80985e23aed1165c51466f426448d24455e420e621d74accd84fb023e1"
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
