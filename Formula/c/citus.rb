class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v14.0.0.tar.gz"
  sha256 "7bb5c840f7990b96ad480462c2e25d1fb3b8129f7ceb3d514cc376a814bd0633"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f8e163c1669fe07f49c9efb0bb176edf0b94811bf06c34b2c0ecd8e673983c35"
    sha256 cellar: :any,                 arm64_sequoia: "f5b32245b518a637010b179d3841df8a3b753a81fad53566147f91272d5a8864"
    sha256 cellar: :any,                 arm64_sonoma:  "41fbcc16dc152cbaca91c37ff3b1ccf6cb091933a23aba97477847cf143d61ff"
    sha256 cellar: :any,                 sonoma:        "eb79e0942e177c7e27b30b58a0e0e1b76db9e1acff793ddc192920dd0e1f2e78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ccad29edead2a14d8c95f04fd5f59c76b7d605631890618c059cc3fd7f94794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c1a2f45e6439acff9b72cccf9f5a745c5cf18c42feb6d8dd329d268703fb77"
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
      libpq=#{Formula["libpq"].opt_lib/shared_library("libpq", 5)}
      rpathdir=#{Formula["libpq"].opt_lib}
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
