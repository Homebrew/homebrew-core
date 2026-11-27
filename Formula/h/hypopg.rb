class Hypopg < Formula
  desc "Hypothetical Indexes for PostgreSQL"
  homepage "https://github.com/HypoPG/hypopg"
  url "https://github.com/HypoPG/hypopg/archive/refs/tags/1.4.5.tar.gz"
  sha256 "9d1981af0c55ac75ab4e2648e0050ee626c1af4c68b24259e3c744ff5211ce49"
  license "PostgreSQL"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "6d61b609b9786dcf9d858475b662a618743c303143486617925fdf208e57ea01"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7addde8847558483ca1e4726f435214ca1216b42145a9a18b4560b404e3ac001"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51d5f98bd5a5b2aaa944a7921bb3207fae0762bc0f6e1fd0c6003e6e4be59143"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ead524bcaa28c67523f4eb8c3d3e4d37bd4a1e262d5bf447dbb56b366e5879f4"
    sha256 cellar: :any,                 arm64_linux:       "feec2c3a54b46618f7f93ac8500e40ea1573c3c45376e599bdcd4080e8e41691"
    sha256 cellar: :any,                 x86_64_linux:      "da9fa072739eeaa04a6bb0d0a7111c7ce886b81866693cac6cb1a5f5fe29ae6b"
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
        system psql, "-h", testpath, "-p", port.to_s, "-c", "CREATE EXTENSION hypopg;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
