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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e212b89b2b4d7a4d17a39c8d193eee0a5fdb1f9302848929f342a49160d84595"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e272bbbdae3fa13431a1e3fe57fd20a706c11747d9fc55c3f721a7787a13f8d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5df8083a2799229eb16de496618d8be628cdb196c52f93f4265f3daafcabae8"
    sha256 cellar: :any_skip_relocation, ventura:        "daf6f7d9dc110bab1af83e5a001d9f75acd9db35646b2db737cb369209282d5d"
    sha256 cellar: :any_skip_relocation, monterey:       "b8f25977f9f58e4ecc5419053537be6bc9269ad561ef49b3cb3637801c951b42"
    sha256 cellar: :any_skip_relocation, big_sur:        "8674a9d574e5aae96b94f7584337040d74e5af5091138a7667c88a2028f0be8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3b80d93a0f78c79160427c17dc453dc287626488e37bc45c967c33adb44a3e9"
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
