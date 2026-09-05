class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v4.0.2/pgrouting-4.0.2.tar.gz"
  sha256 "2faf31b178db969637c1f392ba3ba18fba8d5aed15bdc73fbb4a53a72c5d0f71"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d12704c19442d61afd50187f824851a993de4bbea906d1919d9bb0a08550814"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fffe88543ddb114f2e6badd7e7c3b524d724352f5fa167e4e8280321880c291"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dd496e843059d14a5def241ee3d36775f2aeb4c2f669864c09e4e87d7ddd259"
    sha256 cellar: :any,                 arm64_linux:   "3019079276e1168da19080bae2a4d9fffff9a9ef9f052277ae41dd4eb01ebdc5"
    sha256 cellar: :any,                 x86_64_linux:  "2545dd36e3b9d2e2aab25e0233986568f2075ec2be2e4b410e709d91f01381c2"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]
  depends_on "postgis"

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    ENV["DESTDIR"] = buildpath/"stage"

    postgresqls.each do |postgresql|
      builddir = "build-pg#{postgresql.version.major}"
      args = ["-DPOSTGRESQL_PG_CONFIG=#{postgresql.opt_bin}/pg_config"]
      # CMake MODULE libraries use .so on macOS but PostgreSQL 16+ looks for .dylib
      # Ref: https://github.com/postgres/postgres/commit/b55f62abb2c2e07dfae99e19a2b3d7ca9e58dc1a
      args << "-DCMAKE_SHARED_MODULE_SUFFIX_CXX=.dylib" if OS.mac? && postgresql.version >= 16

      system "cmake", "-S", ".", "-B", builddir, *args, *std_cmake_args
      system "cmake", "--build", builddir
      system "cmake", "--install", builddir
    end

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'libpgrouting-#{version.major_minor}'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgrouting\" CASCADE;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
