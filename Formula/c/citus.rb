class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v14.3.0.tar.gz"
  sha256 "1d024dddcf448e553994b07d8def22d6db30dc27388560c98e602721eb6a63f6"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ac819d8486fcf4ed4c4f1613fbcb81d2cd8ca671e83a7c6817ec3a2141af21fa"
    sha256 cellar: :any, arm64_tahoe:       "1d67147c5193c45df3fd0a093991fdbe3db9bf6c12391e588b97cad453baab0e"
    sha256 cellar: :any, arm64_sequoia:     "9af430e377cc19d6c71bbe03c000d15a63c77fe967c9e0e24a7d5d6ffefda26a"
    sha256 cellar: :any, arm64_linux:       "1536fcd453b75224d2f112bdbb7093e08252c908cba21c5e00a1db1d695a9955"
    sha256 cellar: :any, x86_64_linux:      "c30be7c7927a695633fcf592868e7846ff70c7430d99a52026e4eb1b074df20d"
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
