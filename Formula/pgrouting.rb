class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.5.0/pgrouting-3.5.0.tar.gz"
  sha256 "ce3a591d57466d64420923b6ac4df10ad27cac9f5e21f18eed66afe4543dfb48"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0282494c4cedd1a34b8ad32721442d759b9fd2046685b7bc88be716f23cb047"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3f9c6ebd9d92e0c82738aff9ac49e7945989fdbc4f15f7374032cf07847d0b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c490ba2692ee34a1de2abd4fbf89aa2930ecfda867d46495ec79b3a15441aeb"
    sha256 cellar: :any_skip_relocation, ventura:        "b78ad7cb80ab65845e235698ad61c34b353f716dc77b753b76b0ed13ea02796f"
    sha256 cellar: :any_skip_relocation, monterey:       "acc1dcc6a16f062902b36831ad6ef837e04a59fe8c098849a28447fa42e55263"
    sha256 cellar: :any_skip_relocation, big_sur:        "45d2e69fc672f02491256a2259485ae740504473ec01b4373084ea92e9be57f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3c2ec0b08ca1370fa69a21188245dd0cfc87677514cc295c96cf792f654f8c"
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
