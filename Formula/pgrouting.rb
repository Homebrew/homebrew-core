class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.3.2/pgrouting-3.3.2.tar.gz"
  sha256 "45ef56271fc451d38675b3c846c46ac5c784ccbb51fe6df77270f2bed095eb34"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da4a462e3b0b8ad4252dbde960f1654183f89412534f15adee3b335ca797b51b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b868ee67cd37ef035ef788a13e2382267ea9e39b1ae64a0e3b9ff3031eea5cc2"
    sha256 cellar: :any_skip_relocation, monterey:       "60ae6614ddadee5c3be8c467ed002bc90df64ad65fe93593bfc099e6da105f66"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1c37e09fbeef1864f60de68b6374e22b0aad6bf6f1c3787df9ae985acaec89f"
    sha256 cellar: :any_skip_relocation, catalina:       "d31374cd447498a9bc7689d007c45c4ec6fd784feb6e28a9302f0f46a492bc13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53eb7a057195593a96297145478d6c54f7d537cfe25670eb6d2a865b56d2d387"
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
