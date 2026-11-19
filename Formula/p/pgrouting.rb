class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v4.0.2/pgrouting-4.0.2.tar.gz"
  sha256 "2faf31b178db969637c1f392ba3ba18fba8d5aed15bdc73fbb4a53a72c5d0f71"
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 1
  head "https://github.com/pgRouting/pgrouting.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab3616c9a9006bc18f8beedd3d71b9f9535695409d50898473598a2b67b06a0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88179814f31cdeb3b498a657d0d2c4369e85a9ee15d90d01318c86276872ec82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43ccdc94ebafb14e4088e6433ed4df26c6e1239fb6533aba110587361c22daed"
    sha256 cellar: :any,                 arm64_linux:       "886ea9b7defac34a9cbe9883a367dc7d211e0750aad32d5beca28d4fd6e2f8f2"
    sha256 cellar: :any,                 x86_64_linux:      "73bd2d968bf999555f012f814a8f3f6ce6305a1d3e7b0f342a09d5fc15d52040"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "postgresql@18" => [:build, :test]
  depends_on "postgresql@19" => [:build, :test]
  depends_on "postgis"

  allow_network_access! :test

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
