class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v14.2.0.tar.gz"
  sha256 "df221da519cea3740b3a538b846ce0ce5bdc082c5f05321f0361b8f5edc57ff7"
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
    sha256 cellar: :any, arm64_tahoe:   "1c62bb79313f8dc9fa5846984f080835e019daa01a34a595fbcfe84329d36197"
    sha256 cellar: :any, arm64_sequoia: "5ba714d6301fa67228652bea3131d9ceb1ca37674acac4705c10f6c6c802c119"
    sha256 cellar: :any, arm64_sonoma:  "223cbc8138935b0b9d9d5dc953157eb983490ed330e8c98a54e1d5fab4065114"
    sha256 cellar: :any, sonoma:        "07c28e3ca3679d14c85e1918cca56af8ce9cdeb306b72cf50b31719aae732680"
    sha256 cellar: :any, arm64_linux:   "9589b7cc1442b68bc2c8691976adce6cf4afd0605f6bef3aa4f1388e07a55485"
    sha256 cellar: :any, x86_64_linux:  "0721d9092c6f35b8f53aacc1ebf029fcdbf4abd69e39e8d57aa97fbdad29a98e"
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
