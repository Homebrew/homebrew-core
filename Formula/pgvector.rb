class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/v0.4.4.tar.gz"
  sha256 "1cb70a63f8928e396474796c22a20be9f7285a8a013009deb8152445b61b72e6"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e3466589872b97d0ae85c623b680a7955619c2320fc49078a57c54d578ade75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fd55d382ae482e08d6448258b1b8f56fb4e7b262bc6e2a44f888598955176ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "204c249bbe791132ee82fae31469bf38007a736049c9b8045f8d235fdf04231c"
    sha256 cellar: :any_skip_relocation, ventura:        "d81c8413a2f5ffd62cfbde08e8c4f9447b20234f216724fb6fcfde32a6402606"
    sha256 cellar: :any_skip_relocation, monterey:       "067039e9d3be6ec5dd402c17fc7e29d84f7a1c0037fdf6044837b5bce481fab2"
    sha256 cellar: :any_skip_relocation, big_sur:        "716e04db16520f3423bb3b58f6e11d2d5709bdc01238b353d28e2a118e03c286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b73b98986c49df75e2c298b7c9ca5008df82e6964ba2f322fa19de9fe11b8e2e"
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
