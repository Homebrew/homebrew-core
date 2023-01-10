class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.4.3.tar.gz"
  sha256 "6f44052cf112808d07ebdba70918b1d7ece45e743f0907d8889583d726a3fc6f"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2ef0bd6c1580c0c03c902e6577d5f43a6905f70a2334319ed5f1a8351bde1ba4"
    sha256 cellar: :any,                 arm64_monterey: "6c21e32151eef0d6f24b2dfe38cae815e7a161bc4ab18790eb4b8144ccc2e0c0"
    sha256 cellar: :any,                 arm64_big_sur:  "56ed0637f6796712ce06ff0d90ddfb0261d87ea47994270a394dffea034821f1"
    sha256 cellar: :any,                 ventura:        "703a98a9674f0c835367c9b8a47ffe1a198c06ac61f4bfd54e645d744c45a10e"
    sha256 cellar: :any,                 monterey:       "43568a612f0f24a06fef096305e8b87e9e1a084af5f27cfc89166083df414895"
    sha256 cellar: :any,                 big_sur:        "46803fe7c388f7c6c20ee6c5345819d17aba50803b413f6790c5a2ccb4de6c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918afd119e7ec3c1f417089c11660e2913269b6ceb6059e8c832f582672b1a9b"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
    include.install (buildpath/stage_path/"include").children
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pgroonga'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgroonga\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
