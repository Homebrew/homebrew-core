class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/v0.5.0.tar.gz"
  sha256 "d8aa3504b215467ca528525a6de12c3f85f9891b091ce0e5864dd8a9b757f77b"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a251dca05b8268948fc840031e5a27ff80652aec10c1805b7580adbafbe26e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d802b90636b7a957d2be85eac32c2e04372ee08e16651031682c1d400a00a48c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60d13134b47e61ad515e567a592a8d97dae3a7b30dfd538279152cdb3c0e6905"
    sha256 cellar: :any_skip_relocation, ventura:        "b4cc58fea3541edf4ed854a51ffdf984c5391dd6469a8eebbeb29e0cd2fa7a69"
    sha256 cellar: :any_skip_relocation, monterey:       "cc79b35c5f5b823e3a11058d9e964b7bcd0155639946a651ab976ae82fab82c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b06be53cfeba3b30ed0ede1690b7aea89ceff93dd0c5cd5773977b3e3f10a2ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7939053494ded4c6743882560015381ed616430242c6b42687b29e47949fa6c0"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    (lib/postgresql.name).install "vector.so"
    (share/postgresql.name/"extension").install "vector.control"
    (share/postgresql.name/"extension").install Dir["sql/vector--*.sql"]
    (include/postgresql.name/"server/extension/vector").install "src/vector.h"
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
