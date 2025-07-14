class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v13.1.0.tar.gz"
  sha256 "2383287bea45dfce54cde9ffc98f3e27bb7cde4deb3f096f9c7a12d1819f5113"
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
    sha256 cellar: :any,                 arm64_sequoia: "8c988a2119282e61fbf4e03a3941e924a8bc4082489c57d75a90333fd8cd4da0"
    sha256 cellar: :any,                 arm64_sonoma:  "0dbb0ab2b0813fb92d808337c653d8b384d832b24d3f5f37ab67f9b19cf46d20"
    sha256 cellar: :any,                 arm64_ventura: "f0ae78c43c959b67705ee5b84642a93e521e5d03e612f7486838dcfc4e2c8696"
    sha256 cellar: :any,                 sonoma:        "9634120c90c62ba5cb60f14b35202846a2f74de81a337fd18aea5bc6b3987dba"
    sha256 cellar: :any,                 ventura:       "b2e437f3451c31e0f2e35c2299e8366392fa906cfc6ac1d700198ef7bffab45b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26c688fd7bf247840977ed194d72ee71094ff4a8a5d0bfc0dca6bb13cbde62cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e0a57a5ba1a3a10d2c49bec152040f606c0d9f697a92f954e9570604476e983"
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
