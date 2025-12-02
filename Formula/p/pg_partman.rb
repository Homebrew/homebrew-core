class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "9f784f9c7707712ed41ffdbd5c354bf17bd2381bdd63280fc9aa3d48d4d95a64"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82794cbd5e4434e0326446f04f7e5e63a35593886fbb152f6ab514c4d547a7ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b56b79bb69484079e62e17d15063e34304c33d05ac14278777b68e0853f0986f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "903d6277f39e552e818660fcaae33ba311fb29981a3805d0bbd729fd0fd614d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e8b03f8533c667336f6933093ee3ed32dfb31ff8e4d4a4a453fd0da6abe74a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99bb5c0cc17f9df4224edf1b2a79b95002a7a453888e1a6dcb10e876916bccaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "892e20035b80affa8e191d43099ec1bce25ccd92c195d7705acc0b0d549de0d7"
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
