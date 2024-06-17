class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "3e3a27d7ff827295d5c55ef72f07a49062d6204b3cb0b9a048645d6db9f3cb9f"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c56840f6d344008d864863de5feff7b47c2bd0c521083d07e5ef49b4924a3809"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf48c9c38dcb45a5646e2148c49d0de6a7099ed316e52b9a3cca5faac1500b5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eda23266bd52c4628e3882d906aa9dad2a7db08d862040c55ad8c946c4e29975"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1dbe58ee7d246699775795b63ef8163b9e0ee89b5b39ea8569872f0321b9413"
    sha256 cellar: :any_skip_relocation, ventura:        "b97109681a98ef37ca016346f8a3133d1ed87d8da0fe55086a6001ff2b5996e5"
    sha256 cellar: :any_skip_relocation, monterey:       "583ba02efc0220db153efbbbd30e8fea14310a60513056db634b5516ecb8309f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fafe8ac83d791278343a73cd2d41511738305e51c099ada727d149481ededdd"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    system "make", "install", "bindir=#{bin}",
                              "docdir=#{doc}",
                              "datadir=#{share/postgresql.name}",
                              "pkglibdir=#{lib/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_partman_bgw'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pg_partman\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
