class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v4.0.1/pgrouting-4.0.1.tar.gz"
  sha256 "21c071983a682e048da28f0f211205a20f27ef3708c0b637b4e6e29994d7d699"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/pgrouting.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cd0feb635504f27684e307855317ac3be2c53badac8eaec7dbd2bf8cb1ff294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7adb1f542f6264de8c91fbf3913b8b30949c8023327bbe692d5ff5d80428a1f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f0084fb3873cbec60d8fe308ca2b23f6445918f99bdf827e6d0e85abe93482c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e097af595e04bfe9980cc34697d9fd4a2dd8a3c32e2f5859aeeae4718891200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88c76b021a919cc69df0bf7a4e5f94d81a97a04c630fc1053e653a623f6dbde4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7fb9d05ddb3b5d08373be7b1fcff16b1c7c00cb36b699b6b25a813a85564c6e"
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
