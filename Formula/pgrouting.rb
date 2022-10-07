class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.4.0/pgrouting-3.4.0.tar.gz"
  sha256 "bdc7917574419ebaef00ea3f6cb485101e00a718dd0edb50f18776f3911975a1"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "250b56ce816f742f1c609bb66adb816e6cae7a8989f4c61e1c69d39e901c314d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7f824aa2a985b91303d7d82a21061921110bd12a596ca60e9caa47d8b51fda2"
    sha256 cellar: :any_skip_relocation, monterey:       "bda55f6e1b73c0d8d6b4b91e917dca9e8c2618e197888217dea29beae17864a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe6c9930abacfb7ceef2bbb551edf44f20bead2044c54700e9df251b10274d86"
    sha256 cellar: :any_skip_relocation, catalina:       "c2e39016df61fe49d28e441d87fa44777c88ee4bf1e4026f21533fac8529b5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f87165d48a805fe51ecd89abd0c6be1fd253a1e414d07446d82614df2badaf"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "postgis"
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    mkdir "stage"
    mkdir "build" do
      system "cmake", "-DPOSTGRESQL_PG_CONFIG=#{postgresql.opt_bin}/pg_config", "..", *std_cmake_args
      system "make"
      system "make", "install", "DESTDIR=#{buildpath}/stage"
    end

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'libpgrouting-#{version.major_minor}'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgrouting\" CASCADE;", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
