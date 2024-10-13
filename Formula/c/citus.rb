class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v12.1.4.tar.gz"
  sha256 "6f8e55bbcae75309192c48cdb7238e8c895fd63e5b785ff798023c8b8b799e61"
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
    sha256 cellar: :any,                 arm64_sequoia:  "f32f83baf5052b4564c889b703206d260016b3f7e69b2693dab22338dda8d598"
    sha256 cellar: :any,                 arm64_sonoma:   "786b219283e84207a8cf2820c7c74e9e61b3f2bf0ba06a10bc32d9e781c1bdfc"
    sha256 cellar: :any,                 arm64_ventura:  "5bb67885ce15fa7298da6923126b7130310053504edc84d2aec88630af21e831"
    sha256 cellar: :any,                 arm64_monterey: "0422a4a7e7891f5102c12c289bea85c9f69f59fd3f36dae47bc297760c470ef0"
    sha256 cellar: :any,                 sonoma:         "362100c937c43c33190c04eef85b17fc1a697649634500d8ed7457bf7668e9be"
    sha256 cellar: :any,                 ventura:        "0e17325da26d62c2cb2a0e60b5adfee79676271c1a93814791bbce6918e8c5de"
    sha256 cellar: :any,                 monterey:       "1584b2586f0a566ab65e88edc40bcd848b67870e0581affbb55ff23a6f5ed277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4363b7e3f120d35f0fa024c82f9903619e0414185fdc9ad466853fd37c30a86d"
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
