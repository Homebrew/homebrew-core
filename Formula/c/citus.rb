class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/citusdata/citus.git", branch: "main"

  stable do
    url "https://github.com/citusdata/citus/archive/refs/tags/v12.1.0.tar.gz"
    sha256 "cc25122ecd5717ac0b14d8cba981265d15d71cd955210971ce6f174eb0036f9a"

    # Backport fix for macOS dylib suffix.
    patch do
      url "https://github.com/citusdata/citus/commit/0f28a69f12418d211ffba5f7ddd222fd0c47daeb.patch?full_index=1"
      sha256 "b8a350538d75523ecc171ea8f10fc1d0a2f97bd7ac6116169d773b0b5714215e"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3feaa17bbc05d3902404413582f22f70b526f55797c357c775654f8c4e55c9b4"
    sha256 cellar: :any,                 arm64_ventura:  "6d9282cc121e512b2cbe73e20f5047af310c9c7c8d2350026acceedced653dd2"
    sha256 cellar: :any,                 arm64_monterey: "6098668e13f985faff1ca249be2999b13f60434a44250c3f5704994384140698"
    sha256 cellar: :any,                 sonoma:         "002a5bd41e70330a8a7efe7c23ec7c320d7bcb1730324fb848a19e075d0a5b98"
    sha256 cellar: :any,                 ventura:        "dff6698a79f2681322cd2dac6d7d190f45123e9a7db3addb985bd9aa61f52f02"
    sha256 cellar: :any,                 monterey:       "50a2bf23c39566f1c65069d816b3dd23ff4c95477e9edb973c08a794db1a15eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab0339a42b57a9bbd0ef4c243ffcc78868f5f7d6c7c72e6b4fd62dc9d576e107"
  end

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "postgresql@16"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl"

  def postgresql
    Formula["postgresql@16"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_libexec/"bin/pg_config"

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
    pg_ctl = postgresql.opt_libexec/"bin/pg_ctl"
    psql = postgresql.opt_libexec/"bin/psql"
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
