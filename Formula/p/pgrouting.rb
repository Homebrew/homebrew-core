class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.6.1/pgrouting-3.6.1.tar.gz"
  sha256 "30231dfe01211f709fca9ac0140454ba6bd812f2b7f45fb30222169cd4e8b061"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5490fb201d471deb24ec99a85f678fa76a032d915fe6f10de7294d31a72dfe12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "102992b235314cadea22e741d7d4328d97e46ad8e987a001d50b3be5d24504b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f3915d32d5ed2e33b2518d8f0de6e0b47a0b7e28b675de470b2ea2ac08adbe3"
    sha256 cellar: :any,                 sonoma:         "848bb1c589144a7e9daa2e78e1fb3d27801f8331d1daa7bf48a5fb4f3764425d"
    sha256 cellar: :any_skip_relocation, ventura:        "d7d8a40ae0f854744305bf2f037c4c89812df6512aabc3d105bc2f84eec84f71"
    sha256 cellar: :any_skip_relocation, monterey:       "3fac5cf65e431513ddd0952f05292e3e120c61d5b12c2544076eda3dc268a6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e454fee47c60badafe032533cfc2f4e9ffb2e00883aff1889ec11f30bab4d32c"
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
