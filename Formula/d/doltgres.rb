class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "bbec749dcb170e0a3d52739aff5238fa0b955989e9c14fb42a65724aeccb9639"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1edfa8a152e51341dae8e5d1bfb5d2ed2cab5acd7e3ad41c47ca2553479788dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58532b8e373a4c6f5f43a6d71c7034aad563622d5e0904deae95ecf8cc86b12b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7d68f6356542586477dab192129867c5f7adb16a09ad0547336b83ee80b9ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "23317473bbaf9f7ca3908520220949295ccae5782c4b7f71017c2aedc707bb27"
    sha256 cellar: :any_skip_relocation, ventura:        "2ac7e5dfc8e186e78e68e8f087be9c35d174eb2bab5c662e805250da18d0c332"
    sha256 cellar: :any_skip_relocation, monterey:       "5b8770e2725330516b2a5c1be85998b8ef3b278eccf7514935a9c9e39b651217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8c217034e376f58a3c0a6439e90750c7bb60a8130bd3ce1d535f3e0b0813ec5"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

  def install
    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/doltgres"
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~EOS
      behavior:
        read_only: false
        disable_client_multi_statements: false
        dolt_transaction_commit: false

      user:
        name: "doltgres"
        password: "password"

      listener:
        host: localhost
        port: #{port}
        read_timeout_millis: 28800000
        write_timeout_millis: 28800000
    EOS

    fork do
      exec bin/"doltgres", "--config", testpath/"config.yaml"
    end
    sleep 5

    psql = Formula["libpq"].opt_bin/"psql"
    output = shell_output("#{psql} -h 127.0.0.1 -p #{port} -U doltgres -c 'SELECT DATABASE()' 2>&1")
    assert_match "database() \n------------\n doltgres\n(1 row)", output
  end
end
