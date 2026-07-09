class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v14.1.0.tar.gz"
  sha256 "e174ed00efba74aaf5a9da87f770f6a7e11274066cce8449d804bc6b17df6ff8"
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
    sha256 cellar: :any, arm64_tahoe:   "30daec58da78aec89cd70d1e285a5c17697f86575dcf5c84bf721808b9d18421"
    sha256 cellar: :any, arm64_sequoia: "9ba960367d986433f73ece1d1dfde884845f1e7febda81823df88f8ad7cac048"
    sha256 cellar: :any, arm64_sonoma:  "81776b862398141a5002213ee2e4b33afa600a2dfea4badb78a1fe421d40ca84"
    sha256 cellar: :any, sonoma:        "1b6403508a36224cc085dfccc84df12febe9c3a752eb0a3d6a6137ba7a5e4c94"
    sha256 cellar: :any, arm64_linux:   "91fdb831d539b354ac72b0a983d9164e1fa76e55650cdb9b0db778d52b879a69"
    sha256 cellar: :any, x86_64_linux:  "7cd6766dabcb900058e68476dd3e646c18798371962c0ff71b3ad5fff589f7b4"
  end

  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]
  depends_on "libpq"
  depends_on "lz4"
  depends_on "openssl@3"
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

      system pg_ctl, "initdb", "--options=-c port=#{port} -c shared_preload_libraries=citus"
      system pg_ctl, "start", "-l", testpath/"log"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"citus\";", "postgres"
      ensure
        system pg_ctl, "stop"
      end
    end
  end
end
