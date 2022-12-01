class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.4.2.tar.gz"
  sha256 "e64965b54fbd773df4b631349507cd8a7ad5119c93f14a4ad76d244358ffca28"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e60730b7637bda2ab6e28c13e26c488eb274791158e4874fa16658560639d2e5"
    sha256 cellar: :any,                 arm64_monterey: "57668a9ff207dcc7935745448592e011efeb1322c464180c670272c1199bd12a"
    sha256 cellar: :any,                 arm64_big_sur:  "a6714f37a4274a7b0a97032de5fe260e48377534ec5badbed950c408baa8be35"
    sha256 cellar: :any,                 monterey:       "add23312a541daaa0477938354b74f91dbf859d35f0398dc41aa6d381e6c7779"
    sha256 cellar: :any,                 big_sur:        "f4afb27ded3f00c6fdd648dee970be40657cf883547081da20b6fab73f018468"
    sha256 cellar: :any,                 catalina:       "6e77c6e9e4f8dfab44016d4abe29367e4dcf9e6dbb285718595b471c1578776e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce347e041f1d61a6b944ca432aa46171f97c5f56e11c6a10494611fbc0476dfe"
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
