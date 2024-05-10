class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v12.1.3.tar.gz"
  sha256 "5b3b20b89ead1f97072088cb1ff275a053ded886e174f8ebe3288a2e7229d92c"
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
    sha256 cellar: :any,                 arm64_sonoma:   "a72deac26a11caa40ae4967a09db73dac221b1df9d4c47b23df5cef0d6d9ce4a"
    sha256 cellar: :any,                 arm64_ventura:  "fa1b2f4c6167a90b3aedd021847decaab153674fad83a6962378e2478552b829"
    sha256 cellar: :any,                 arm64_monterey: "1703cef0e36a0d52ba7a9567ae1c5b1d4aef794318d4def84ffdfe15f1b1451a"
    sha256 cellar: :any,                 sonoma:         "127da8ff2a8d1714c874faafa34010584d05ffdfe88f1216fcd280ab995abcb7"
    sha256 cellar: :any,                 ventura:        "3a268aad9b4a8a3d6f3525572dde6e9ebd84a764dcd2ecae541e3ab39714ace0"
    sha256 cellar: :any,                 monterey:       "6b2c83a3d6b4fe46ebcba8c7feabfcf0d9dd13166ba6e517882eee83fe5d959f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbcbf8f822110640d4554c1bcbda7d442559fa9f0518220be0d90ae56c18dfdb"
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
