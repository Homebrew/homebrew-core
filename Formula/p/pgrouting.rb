class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v4.0.3/pgrouting-4.0.3.tar.gz"
  sha256 "1cbf127cc3d73a7244ccc6ce1c47afb464e14628495ae3da1f9326f957351317"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/pgRouting/pgrouting.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "306cf6e684867f97ac6574709b19a78d9c3703f70fc03790d8d8da9e5251727b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "64ccbeaa43ef1a508503504c435bcd40a6e1dc1771caa3d7a6029fbc3dc145c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43d54eb8008dfb8a990ec697c7b824f0782ae6e52ced2396f1d0b99b88197cf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "185551421bc2bdcda2e816b90820fac668f2396d66a23fc1de746b600d8d3e2c"
    sha256 cellar: :any,                 arm64_linux:       "b06ea750f3a41629be2ca62f66954e0cfc77cf2f3387bc2cb168111e26beccfc"
    sha256 cellar: :any,                 x86_64_linux:      "2795256ba4e1798e25a5d2ed54adf0dae2082e154c19dbc3f1d8e262f73a6345"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "postgresql@18" => [:build, :test]
  depends_on "postgresql@19" => [:build, :test]
  depends_on "postgis"

  allow_network_access! :test

  def postgresqls
    deps(/\Apostgresql@/).map(&:to_formula).sort_by(&:version)
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
        unix_socket_directories = '#{testpath}'
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-h", testpath, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgrouting\" CASCADE;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
