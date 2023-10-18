class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/v0.5.1.tar.gz"
  sha256 "cc7a8e034a96e30a819911ac79d32f6bc47bdd1aa2de4d7d4904e26b83209dc8"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd35ed8d3861f7a63b2e3ecb3e313a1d04c692217653047c26445e8267d068e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3aa310ce6b3d8983b272e65a07da1b88ff70029bf4c7c345543daadbf313395c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbc637916d4d5d1f48ecacc31f0eb84932602aa65966fd03e2184fc414abf02d"
    sha256 cellar: :any_skip_relocation, sonoma:         "47dcec2eba86593f17bb9c70f1df0f7e32b2164af985e89ff132f3c4336b06f9"
    sha256 cellar: :any_skip_relocation, ventura:        "fc3096f2ad79fff305effbc82c6432b3fa86eb1b2296079822520bb3b2444062"
    sha256 cellar: :any_skip_relocation, monterey:       "7245dd8df790678ca7708eb0a243e67f9bb7a3ac251a64eb4563a2087bdb9bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "125ac363467a38139f439964cdfddbae17632b1d4615ebcf55ff697ad38abfd8"
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
