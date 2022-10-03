class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.1.2.tar.gz"
  sha256 "1cdc917606dc4fdbd3eb7cc6c98171713c50a9f31f3a872f6e295546b1224244"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa51ee613a554c31a4117698b4f8c6ddc5683d41587476292e00feec13431d66"
    sha256 cellar: :any,                 arm64_big_sur:  "fcc2952a25c841c4e8290b858c8a8fb202eecd8664a2540002d6f121e172dca5"
    sha256 cellar: :any,                 monterey:       "0cdc5ad625ab1759bd4356556d96bc4d8ef3ac81850309dfba68756af0509632"
    sha256 cellar: :any,                 big_sur:        "d60761a2eb7883cea5ac9ba5012c7daac3a7f8652265db7c4704d608847ba845"
    sha256 cellar: :any,                 catalina:       "c2750d79bd78c0a24e242a212ddb8653990c4f093106167f5f81a7a22bdbb2fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c545edeae9d4e3f83a0d2931a27865e0dc7d5cf56af4a6ebcdb3ee8e9b2de6"
  end

  depends_on "lz4"
  depends_on "postgresql@14"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "./configure"
    # workaround for https://github.com/Homebrew/legacy-homebrew/issues/49948
    system "make", "libpq=-L#{postgresql.opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    include.install (buildpath/stage_path/"include").children
    share.install (buildpath/stage_path/"share").children

    bin.install (buildpath/File.join("stage", postgresql.bin.realpath)).children
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'citus'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"citus\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
