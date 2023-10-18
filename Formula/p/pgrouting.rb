class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.5.1/pgrouting-3.5.1.tar.gz"
  sha256 "fb0d9ef3247a95166e172412734fda9746233912601a4891cbcf02fe87764140"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef3cb20c9c0b654bc9c7f96c4664e7bdc040cbd8e098eb9e48cc7a598d1bb530"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26ae5aeb6db94e9da691ed81a4be05994398730a800909d3fd3ae236295ded24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b26288f9833c98cfe48ae40f991b8c08f01ce1e820e506f2e3c99f0a70f29ebf"
    sha256 cellar: :any_skip_relocation, sonoma:         "060a8154f509bd913706a97e348fd686325f684772cc43058428c344219b4266"
    sha256 cellar: :any_skip_relocation, ventura:        "5bf098ea7aa1dd85a73b218b1929700b9736939807cd9b17fbb647ca1eb3d594"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a4fd2dddcd4703752f44a6ab9c2bae75dafa4ba57e2505f48019323c374a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f148f8d642b78601414d57a203e09cef54286431bd7f66db47fb705aed951abe"
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
