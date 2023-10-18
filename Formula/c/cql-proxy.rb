class CqlProxy < Formula
  desc "DataStax cql-proxy enables Cassandra apps to use Astra DB without code changes"
  homepage "https://github.com/datastax/cql-proxy"
  url "https://github.com/datastax/cql-proxy/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "fa2dbae0622d1a4d04db54db4fb6ef0a1857eaea5a300a5145c529ccb4b17d66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cc51530a2c16d3a205eb62c5a080411f1614bf820d4dd6d27ecd979ddb803d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d1c859be99b70b4ed639f01dfc01901b2aecc8fc9254866510b6a90a9dc95fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4f83b9f47cf33db592085177094a3bd6761d771c0d36a3890f12fae0894c4e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c166d1573d484f603b38c8438a4c74e1080fe69cd6575ed7de17341fa3e1662"
    sha256 cellar: :any_skip_relocation, sonoma:         "772daaf55ce951ce03126c6a26414d4289b7293b8e0cad0f60cdc03d38c99837"
    sha256 cellar: :any_skip_relocation, ventura:        "61679d7f18fec195f74e19979327ad19c7ef3a87abbe5af41fe512f7154868f5"
    sha256 cellar: :any_skip_relocation, monterey:       "13d172a29157d6b9cf77aa99cfaa2b196032ea52154c6f0c5fbbf508e3c50e74"
    sha256 cellar: :any_skip_relocation, big_sur:        "448efcea0d3b7217009df6937673d5bcee2e1bbde4d933cc9970e65086825480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b770257cfc9817d035b33087d26e4873126268b673d285b4ca421685a66db94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    touch "secure.txt"
    output = shell_output("#{bin}/cql-proxy -b secure.txt --bind 127.0.0.1 2>&1", 2)
    assert_match "unable to open", output
  end
end
