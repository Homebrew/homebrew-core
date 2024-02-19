class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "b0cf4ba1ab016335ac8fb1cada0d2106235889a194fffeece217c5bda90b2f19"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "467a1a44de523bed6f24fad5664e337b4c1723a888f52b057ac04a4810adc8a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2737a68674323bb17a8e1b973a37ed8c8ce64357eb07de57521f5d1d1a1db60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "254abcaf5fe81bfef9151ba5dd37260d6b7841106c15681287b602e3a8339506"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5aa1b183b95748230cb110c33c4aabbe1ae1a423e9eac55d94830f12398fb2b"
    sha256 cellar: :any_skip_relocation, ventura:        "3cb6413ccbc7638b3ee9a5afe8b6d508f0800cdedba56516ac0d3f5656e2f802"
    sha256 cellar: :any_skip_relocation, monterey:       "eeb0210adf1df40cc9c7eafa700ed449e9bcca63fb37d9e6e4573d99f6fbda66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7ef44461956be1624c588f440773613350aaf25e787c3561c76b267731c947b"
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
