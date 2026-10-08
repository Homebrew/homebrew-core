class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v14.2.0.tar.gz"
  sha256 "df221da519cea3740b3a538b846ce0ce5bdc082c5f05321f0361b8f5edc57ff7"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/citusdata/citus.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8bc77538903bd9be8c76f248e7cd7a09b77fda341b28b08a5b57a6add9094ae4"
    sha256 cellar: :any, arm64_tahoe:       "72d29c2a3a8bd7d489d164df9b1288c2a66cdde3b555af293e97471d1bb2c5e4"
    sha256 cellar: :any, arm64_sequoia:     "81c1acd2b3a77a78bb80c27e6fb99ea15a4ef60d2c213eb15582ef0cd8a265d2"
    sha256 cellar: :any, arm64_linux:       "5c0a2d635595cd9a6237fbd9effd9991b98093f0f78ade6cb381790ad6c34ad7"
    sha256 cellar: :any, x86_64_linux:      "058e394199a8430c1d33d6a29b52e1617a0ea1512f5021dbede09be2d59ffc0f"
  end

  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]
  depends_on "libpq"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "zstd"

  uses_from_macos "curl"

  def postgresqls
    deps.filter_map { |f| f.to_formula if f.name.start_with?("postgresql@") }
        .sort_by(&:version)
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    # We force linkage to `libpq` to allow building for multiple `postgresql@X` formulae.
    # The major soversion is hardcoded to at least make sure compatibility version hasn't changed.
    # If it does change, then need to confirm if API/ABI change impacts running on older PostgreSQL.
    libpq_args = %W[
      libpq=#{formula_opt_lib("libpq")/shared_library("libpq", 5)}
      rpathdir=#{formula_opt_lib("libpq")}
    ]

    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

      mkdir "build-pg#{postgresql.version.major}" do
        system "../configure", *std_configure_args
        system "make", *libpq_args
        # Override the hardcoded install paths set by the PGXS makefiles.
        system "make", "install", "bindir=#{bin}",
                                  "datadir=#{share/postgresql.name}",
                                  "pkglibdir=#{lib/postgresql.name}",
                                  "pkgincludedir=#{include/postgresql.name}"
      end
    end
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresqls.each do |postgresql|
      ENV["PGDATA"] = testpath/postgresql.name
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      # Keep the server socket inside testpath, the only place the test sandbox allows unix sockets
      system pg_ctl, "initdb", "--options=-c port=#{port} -c shared_preload_libraries=citus " \
                               "-c unix_socket_directories=#{testpath}"
      system pg_ctl, "start", "-l", testpath/"log"
      begin
        system psql, "-h", testpath, "-p", port.to_s, "-c", "CREATE EXTENSION \"citus\";", "postgres"
      ensure
        system pg_ctl, "stop"
      end
    end
  end
end
