class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "a3f100ae871677f0012579f58542c174900297f664a4ad2be0256e7ee5e33502"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18c89267abe429d31fa63d1f9920959dd428e8492690afe562f7ec8edcac0da5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a657498e05914cbabd51e078a3b9bab7a16b04e14731d2b765bb10fe96c16c66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dd3be1c8ad300fe3437f7b6099626f453974d8d8a575ecdf8f430f546b5d952"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cf572b39ee7866988e601eb2741ccd9ee90fe883fb2dfd413d6d4aea6e20ea9"
    sha256 cellar: :any,                 arm64_linux:   "fe379b2bf29971be8bd12d4ce1945017075f37adb2184686cb9adf0a1a9220f9"
    sha256 cellar: :any,                 x86_64_linux:  "355e53753f0b773ae2d447069fd227d50d6640279c17b4f3ece9bb8561b9373c"
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
