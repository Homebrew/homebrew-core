class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "617fba855c9bcb41a2a9bc78a78567fd2e147c72afd5bf9d37b31b9591632b30"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0eed4f81fcd136fde91361839255f29fb81df63a8796c2cde289df7d98961eb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55d7b398d4fabf284531305f6413125458adec0b73cf60973fb58eeb58bef603"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb04d8d99d8c66f9b44cb2f8f7c523643791151797f5ebd37166ee11f4e48ca9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ad636a1cbfdf65498bede546865033798d6aa15f0f8448d6b40bf6e8f6f13e0"
    sha256 cellar: :any_skip_relocation, ventura:        "6e8c122e1a6ce76fe1af6830b31a288a30362199fb6ba84f0c9887d240f467e2"
    sha256 cellar: :any_skip_relocation, monterey:       "47239b5717b61c2c362c41495947925d8ea1355c10a5b29578ab2fd67eb07568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66d4f32b8830ca8c40c7cf3486aac4f8421a0cb980b89682ebff457946fafc94"
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
