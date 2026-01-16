class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "22d3c186c0504e4620f2971318f295903e16b3b39f4db991f37227fc97dc5497"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "432573032ebd12810ebf31836a0a4b59e75f8bb15786a6e8ed4e3f18a41b4fd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348f96619ac34b8afb3971e52a250f02ab363dd66887ea81e978d0083eba3ee0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f1f6b9abde63155ad8a8bdf4b6768a7ec0649d28297bc462779576f409f3367"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4f512b8943665b39dfa92eb333552e7f098eadc5635041e8e012c50e4190e2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "795e4f9ab4a429350d2711fdc3f775e8e8372577de75c9d82d2a09077414d7c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3f3463884bc7024af4f69673823db07e2b24903e2202528e82a7d58b26f1b74"
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
