class Hypopg < Formula
  desc "Hypothetical Indexes for PostgreSQL"
  homepage "https://github.com/HypoPG/hypopg"
  url "https://github.com/HypoPG/hypopg/archive/refs/tags/1.4.2.tar.gz"
  sha256 "30596ca3d71b33af53326cdf27ed9fc794dc6db33864c531fde1e48c1bf7de7d"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e319bf2b836a72e560bcb3496f80917f29cb2d9a4243580a0c1487f7e4b7c9da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e641b2c2df8ca7f8a6b2c882b42f820f24a3e9326a3605dcfeb97770149889e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cfe4430907140af1fe4e26ab9ab97c0180e570b7d9c55d1c03932ca050e0566"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1f748e156c8e3fc1ef64c3d0741df3d8f69cc1c7fd8468576db210b6bdb92f8"
    sha256 cellar: :any_skip_relocation, ventura:       "37dda840487b942c69f32b88347fbb57f279ee780e385a5a8d6ab653d09e70c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "593f3fcf8179281606f2dd9e22248ad010cea256dac2a17d567660bf0b93ce0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21cc0571fc75444925050a5856e02b3100ca1e5698adcaddf21b6dde1f269d42"
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
