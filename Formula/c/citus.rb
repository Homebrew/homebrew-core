class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v13.2.0.tar.gz"
  sha256 "82cc117bb1000da9eeea1499ee9a8f2706feccc19e2c5ca623274793d98a217a"
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
    sha256 cellar: :any,                 arm64_tahoe:   "9fd8554e2257129eb8807145d02fb5c484fa8f181e6af43f9d329f6b3c4d49c9"
    sha256 cellar: :any,                 arm64_sequoia: "eca6c59df04f920a84489a9954e6e7631027682dabe7da50caf89b92d259a03c"
    sha256 cellar: :any,                 arm64_sonoma:  "4f0f2c768e2eaa1bcd6bc81bc9cd85a98129e95c0b1787abb8c4492d62d5d2e4"
    sha256 cellar: :any,                 sonoma:        "5db290f355866693b94d675f6413c51a61b3d318b69123037732881428ce3502"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6480fc45619139069d2b2e95defb953ff6d1eabffb60647c7d5ae48849f218a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c084d5b9768d67e534439f61967698aa7a673509ed55b486a0da2d464b711c0a"
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
