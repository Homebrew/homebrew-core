class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v12.1.5.tar.gz"
  sha256 "bc95a30e93459f0398865e9dced53e61e758483b78c9fdc4eab2bc1317db2ea4"
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
    sha256 cellar: :any,                 arm64_sequoia: "9e940ccb91123ca14d3c286e47bca26357a2d6bc37c5af2ad726c800ea0cd511"
    sha256 cellar: :any,                 arm64_sonoma:  "60cfd5a3aa56d439ad2fc8762267ac91f459e209c1de60574c6d20bb1b2bc6f2"
    sha256 cellar: :any,                 arm64_ventura: "e87a8036cd8bbe60c7fbfe001cdbd5e09cb1e06cea2bea884eab0576254a04f1"
    sha256 cellar: :any,                 sonoma:        "761870536febbfecb3e0ae65460e202fe36a0b412dd2a643ec300c30caad1e75"
    sha256 cellar: :any,                 ventura:       "9de6617cd2c7accd7640118e45fd800a5cf801d4eccd63f5c7df6b8f2b2c6cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6157dc81d6fc2df83b60c8d016257a9473a34ae731331945b0d6db7fef6ce1d2"
  end

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "postgresql@14"
  depends_on "readline"
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
