class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.6.2/pgrouting-3.6.2.tar.gz"
  sha256 "f4a1ed79d6f714e52548eca3bb8e5593c6745f1bde92eb5fb858efd8984dffa2"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b52b48a48c4b3a31d1d2108ab218e7c64642d5dfe8fe2e5542110379f206b452"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdd74845f8712c27dde09e677efc5f61185286c5d4dcaffd2957e1f2f43cb078"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d6781d06872f26d8d8241b440bdd0dc1df1e652c9c84778e37ca6aaf3f27a9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4a7d141b8df468e8d66852f2d1639c07a319734cc898b829b2740780bfce578"
    sha256 cellar: :any_skip_relocation, ventura:        "be72ca847766199f95fb99e58c2f25f101a86aeac1116a6ab8ec00d68eef28eb"
    sha256 cellar: :any_skip_relocation, monterey:       "bb08d1c14eae4b92a51433d5becb5f8c074e87513d10429d29a88f9e0299bad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9d83c063ea735b32fb4e1abdab9d567003c42c3fe8144bbf648e3147167d6f7"
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
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(/^llvm(@\d+)?$/) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

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
