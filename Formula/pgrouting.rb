class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.4.1/pgrouting-3.4.1.tar.gz"
  sha256 "a4e034efee8cf67582b67033d9c3ff714a09d8f5425339624879df50aff3f642"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2728491677fa97b87d47f07b2dccb6172c6c68eb917e188df238efc356f17fbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f81ba001e9111d207d2b50de3a92d975f15cccbf0130a3e1adb549021d0a57e3"
    sha256 cellar: :any_skip_relocation, monterey:       "9ef8a5372e6e6c325cd9ad9e87732dfae56e1c25e1f1b30abb3ad73513258ef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "51161de88b68efb96b5bbc7e56ed03eaf47b5c8ca23f26e1076dc328b7293411"
    sha256 cellar: :any_skip_relocation, catalina:       "15a870729bdef0f957a55f6419ffdbcadef362fdb66d3fc82413016c15fa0750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5440264c3054facd8c74b95c1d435b1370f4ab2ab9a945f44d09fb47207e7ad"
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
