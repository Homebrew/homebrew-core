class Hypopg < Formula
  desc "Hypothetical Indexes for PostgreSQL"
  homepage "https://github.com/HypoPG/hypopg"
  url "https://github.com/HypoPG/hypopg/archive/refs/tags/1.4.3.tar.gz"
  sha256 "498a961d88cf37057fd9e98027d06fe805c8959d51895c3d9b94c9eb4e14f706"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd9b3f0fd688be3fb87a4358ceb1fa26795d0656e4259471c1dc4d06226e491c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4400da6e1c03a1191731970937b77bb51658a3d511a8072a4a5d6b1671ebb334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb8da815fc50ef28c904f5f2e708362fe1a009edbe296448d405dc7475eaa7b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "134f43444d5b25257deca0e280efac9402ab8b4463b917a46bf0224a4c01ec8d"
    sha256 cellar: :any,                 arm64_linux:   "342602a4162d72a7c3f422402224da25921ef6e8decc2227cfbae9eec920dee7"
    sha256 cellar: :any,                 x86_64_linux:  "a684953f0358ecc052b5ac2d27387d837c3557423bf8a6e9674ab8f2b130a4f6"
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
