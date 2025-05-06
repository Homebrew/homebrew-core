class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "main"

  stable do
    url "https://github.com/citusdata/citus/archive/refs/tags/v13.0.1.tar.gz"
    sha256 "b7fdc3ad6eca9dd6a1066e897a249fdca289e96d81921d4c7bf98cb4302ce817"

    # Backport DLSUFFIX usage to fix extension on macOS
    patch do
      url "https://github.com/citusdata/citus/commit/0f28a69f12418d211ffba5f7ddd222fd0c47daeb.patch?full_index=1"
      sha256 "b8a350538d75523ecc171ea8f10fc1d0a2f97bd7ac6116169d773b0b5714215e"
    end
  end

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49acd5a24baed73f5b367d97fbba89285cfa515fa359d6176cc3850a92f56e6f"
    sha256 cellar: :any,                 arm64_sonoma:  "44ec4f915050291b58f02e8423a2306d5c24a67ef1fa66cce65aec913d0489df"
    sha256 cellar: :any,                 arm64_ventura: "87853877c161b9c1f533871c4948d8e9df5018d4f9cda31ad4dafa60972e3e51"
    sha256 cellar: :any,                 sonoma:        "68a85ce9faf1bd1adbf6745daacedbb320cc691001740750d92e10c8b92198c7"
    sha256 cellar: :any,                 ventura:       "a6fbe35a9813c2b2bcc8eb7b05487bc1a20c5e02c41d7e7813b57b78fcdd7cbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9071869ac5660e49bd27acc7e2dfdcf3d258749c4575b13f0b4f703bb48811f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42694cb8148e29b50a36b8ce0b48853be1d0a46b9f59a1dca1cee7b5b80b55df"
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
