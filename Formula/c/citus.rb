class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/refs/tags/v12.1.2.tar.gz"
  sha256 "61d959e8129df4613186841550ea29afb9348a7e6f871d5b5df4866777b82e24"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f5543af7bc996b1cbf67aa5cec35d6946e6d2c775ec6a12e9f2acbf8e8578959"
    sha256 cellar: :any,                 arm64_ventura:  "baffacb7246943cfe87f1c970d53cf4e99ae3bbb577769acceb6108ffa6909b5"
    sha256 cellar: :any,                 arm64_monterey: "0fe37a14ff92c081286f7839ae98173e9105f58170432d6db526a8fdd2e1c520"
    sha256 cellar: :any,                 sonoma:         "d964c3510ccfd8d6f9981009f6fe40d6fec1d636c1d1af52953a25702ef942ab"
    sha256 cellar: :any,                 ventura:        "743aa322fbc40eab84ccdaf28bf61ff9d8b472bb5682421048d396bc6c8e0dfe"
    sha256 cellar: :any,                 monterey:       "6f2aa7ac65821de64306329b75c3f8444b64c7681f0459c884e7ab22eff8a63a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "350dd049a60f29a9c462721789b00e544b464522ad161a5468263689cf5196b6"
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
