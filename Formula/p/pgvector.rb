class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "a11cc249a9f3f3d7b13069a1696f2915ac28991a72d7ba4e2bcfdceddbaeae49"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94d298bc4aa736c2cd9196660ec8484ddf226abbe1ead953a382f434f65e0a94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a91ddd8f4f17043ad4ce7cf088ea70868a83b571f3d0cf074db5abb2020af2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0642da922542d80fc8db425dd5060eb923808076933052cba71d3dd25b313ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f7ef3a232ccfd1f59a93f1a9f3ea3a32cea115d91e16468ca864ee6f6623bda"
    sha256 cellar: :any_skip_relocation, ventura:        "9af4aa06cf474a6ad3ae102b081ae60e940e66f7b319856f0ecfe171d0e1a4c4"
    sha256 cellar: :any_skip_relocation, monterey:       "f49bc71b41aefec97a0d8c9c5f84b4a9fbad361c192c555dd72219998d2767db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af37331ef5e58071d44f9140d1ea23921b667c5fa2b90c252ebc139696d22e62"
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
