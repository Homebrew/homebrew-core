class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "1b5503a35c265408b6eb282621c5e1e75f7801afc04eecb950796cfee2e3d1d8"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab47a8f281f589175d1288d5b9b32cda768a471c3884406c0dd549a494ab0ce6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a1beb6a1884c509434f42d330ee8145305e904d19865ef371e0339b1fdddc37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5a319dce4f149ca3ca3a7c79135706c77d88352b2d5a2850fb16d61651509eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "757221c0bcaf2e6fb5134987a09691b9fc0efdf4c6c4c67b591ddc4fd93d7936"
    sha256 cellar: :any_skip_relocation, ventura:        "dc80380565d1a6bc3dbed361ddb00793310344683108bac4a1ee383fc2f933b9"
    sha256 cellar: :any_skip_relocation, monterey:       "df847410a1b876eac5732a770daf7c574e91c910a9877bcfce603a47eced407d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04669a47f98c031ebf556d8225e7c38d95e002ca1e9b1ed7904bc9c12da1216d"
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
