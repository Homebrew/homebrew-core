class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.7.2.tar.gz"
  sha256 "dfeccda372f8298a84a8b4bceebb4fb2f893e77f232e6b5d453db1652d345c78"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ae3e85126240fd24fa213b59eca3471a5f6091bbded991e4c33f80310680120"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa8503477ab71c480bd363c1e7c4307c41f7d267759ad7104b9b9ede4993a442"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3eced5d3fd65b01be22fcf5fc0ca7754e8d0f33b95e6e6242937ca5714e86664"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2bedd64e6d81f40d1c6bfeef83ad6cd977aa958a5ec38f524f76a4e903e74d9"
    sha256 cellar: :any_skip_relocation, ventura:        "3f2cc0fc5baead4e9853dcaa3009c69043333a6da93c9b11165ed0cc8ede9a5c"
    sha256 cellar: :any_skip_relocation, monterey:       "82e820020ca49308b5602cfd8d34d14c10c1a0fab71e7d4368148931221ffb44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb434c8789c0d0b1fe858eb2573cd97a9c52cf34b04872b03126a10ace8f43b6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/clair"
    (etc/"clair").install "config.yaml.sample"
  end

  test do
    http_port = free_port
    db_port = free_port
    (testpath/"config.yaml").write <<~EOS
      ---
      introspection_addr: "localhost:#{free_port}"
      http_listen_addr: "localhost:#{http_port}"
      indexer:
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
      matcher:
        indexer_addr: "localhost:#{http_port}"
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
      notifier:
        indexer_addr: "localhost:#{http_port}"
        matcher_addr: "localhost:#{http_port}"
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
    EOS

    output = shell_output("#{bin}/clair -conf #{testpath}/config.yaml -mode combo 2>&1", 1)
    # requires a Postgres database
    assert_match "service initialization failed: failed to initialize indexer: failed to create ConnPool", output
  end
end
