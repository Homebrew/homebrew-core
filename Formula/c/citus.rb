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
    sha256 cellar: :any,                 arm64_tahoe:   "e309102533b5335516bd9497f53b60982dcd7e7010d909c01f9b6bcbdb0e1d28"
    sha256 cellar: :any,                 arm64_sequoia: "5702c52b34e0db615adde34571abdabe56386672946352b4debc35d050fd33e3"
    sha256 cellar: :any,                 arm64_sonoma:  "9f119d5071165eda287caceb1d3c927a0d5825a439f841953e0920ff5daba95d"
    sha256 cellar: :any,                 sonoma:        "2b78fa1d40528914b0f66dbeb1d558ac56314d2bb4474eb99ab019cb8cb3db8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd9dfe810a77c8c29d46c5e562d7d2110f1ed3c12fac085d3255d04994d2caba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2844b461a1204133de4f73bfe093091043145be5803b920537b01165b88e2c26"
  end

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "postgresql@17"
  depends_on "zstd"

  uses_from_macos "curl"

  def postgresql
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("postgresql@") }
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "./configure", *std_configure_args
    system "make"
    # Override the hardcoded install paths set by the PGXS makefiles.
    system "make", "install", "bindir=#{bin}",
                              "datadir=#{share/postgresql.name}",
                              "pkglibdir=#{lib/postgresql.name}",
                              "pkgincludedir=#{include/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'citus'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"citus\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
