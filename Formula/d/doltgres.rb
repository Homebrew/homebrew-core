class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "8f5152f65280b4c7747aea041e8d06069044e9c858299303d0eae3b1a576932f"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17166b647538f54ff592c9f0159c8f2df86c75160c68e2bbc5ec0bdca8da52ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61d16a440f18e1e972199d94750037c97101a7989bf9ea008b4e4a5f8b54a14b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf05be4f0195f2f5d69893b2c8b6778a4bf04291da8e5c1630b2e621f596516f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b39531a1d66aca335c18d0b134e8f29701ba4b6de5013c680c51e22b707a6adf"
    sha256 cellar: :any_skip_relocation, ventura:        "f4daeee4e11d7b59d3325330b34714a551dedc52ae26ac4ebcad76b29a7cb76a"
    sha256 cellar: :any_skip_relocation, monterey:       "5261b2981be63554185112bfac99a93ba3a7633601e292b70e6e76c5cbce7674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23ee7dd2ecd12723397f0c028def9e2c49d65032b70302552947a4e7c8d40cc9"
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
