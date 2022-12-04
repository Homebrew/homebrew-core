class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.4.2/pgrouting-3.4.2.tar.gz"
  sha256 "cac297c07d34460887c4f3b522b35c470138760fe358e351ad1db4edb6ee306e"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8351f53f6fc0dbb8e94059beddf66cff5f4e1ffd34d024092d517dcd5fcf3ded"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fcde93296f010f76198e9284f3d3ef8a22610fa875602bfddc07afa1da0afc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b493cd1c18c32f947f1d464b2eba0bfed8222bc2e49e7c520461fc72e91a9168"
    sha256 cellar: :any_skip_relocation, ventura:        "89af6917b2d274a5943e27f45159d689c26bb1c4101f181d0aed21cd2eb1a064"
    sha256 cellar: :any_skip_relocation, monterey:       "8eafc7eccd8b6c19efc47f5d92aaeb6c6512ecf9a1c40a8e1c430f44bde25623"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d42f13b00a4f6df2eee051d368df0e97677a519a082b92850e42816a0139a75"
    sha256 cellar: :any_skip_relocation, catalina:       "49449229bb48fa7c6da74afeb54ccd0faf7e1dfe604a97801b82c9f873b55d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3213b33a1a52308497ebb8896b731ceb5eb17946b66fd4ae71d38270afc2771a"
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
