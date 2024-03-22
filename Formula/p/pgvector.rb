class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "a11cc249a9f3f3d7b13069a1696f2915ac28991a72d7ba4e2bcfdceddbaeae49"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "400abc5d676e8f921950d9306d7077b0f27b31a52d239987c7284fc7132d3c31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df5aa01e244ee9a2d1d660e8220496b42267ecd5570dd26eec374d34ddc1af15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c833ccbc7613e141fcfc5ee50074f916b291aac1288c701d7fbb92242936beb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "47bb7c3892c22b82e070903212a8c233fc3c94289996a088f33fd7265fe2a9ba"
    sha256 cellar: :any_skip_relocation, ventura:        "e40b3fc30a9b3602426073603a9ca46e2390d4bfbb740bb83d7dcab018f27c8d"
    sha256 cellar: :any_skip_relocation, monterey:       "a58f42db7efc0ec83bf38dbcd5ad46dccd441e1d9743302808a4ca10d8bf8d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44bf6411dc50730c0171e5cabd8d5ba6a74735933723db04bae4b56bed4112a"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
    system "make"
    system "make", "install", "pkglibdir=#{lib/postgresql.name}",
                              "datadir=#{share/postgresql.name}",
                              "pkgincludedir=#{include/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    datadir = testpath/postgresql.name
    port = free_port

    system pg_ctl, "initdb", "-D", datadir
    (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", datadir, "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
    ensure
      system pg_ctl, "stop", "-D", datadir
    end
  end
end
