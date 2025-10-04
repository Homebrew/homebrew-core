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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62a5a0b0c592109dbfd59cc2ed251cfc61139444fa11dd43c6a813bf5721dc05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdeda4712d8f810bbef1018e34bc93f250736e7d06b52c46237fb72f0203d6b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5944371d52b74079759b3c1697219a83afa8668897d99727d3a8178915d4a0d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "489ad1c03c7445f390a0b5343368138b5e7f9fcd09f2d93cb2788b77d82c02f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85797620c0d3f1115917e23044e64b4526d2913b15044a6156d3c69037ca23d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a2cf8d3428a7e9e63c750f8fe2d45a5d0235c0b88d661089e1bc72bfcebff68"
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
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION hypopg;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
