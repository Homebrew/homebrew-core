class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v4.0.0/pgrouting-4.0.0.tar.gz"
  sha256 "ae87d30652b4a7824509e2652e02bde19e1a42c37906cdf1824b5df40af0bfd0"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54666eef457b30d344fc22df0ba5805a858c437461b4e2792e61a721da9ade87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb93e2d574ab28ea6b89694292636c55c2e977cf18f8f11c2be0c299d0519164"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef6245564c6014e84263a954eff9f905bec78ce732a204b07f224317efa73998"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b0a15f53bfea899254a307b5385a566f32c766c9b9c5b7ba275f0af1bc5d02e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f9e8c29472cb6cc1cb9f2a845cfb20504e00ed8bb0239dbb2fc8486ff73c4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a400606bace6b3281c68c641b8d675cca6913e6cca426a161194e2577a4144b7"
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
