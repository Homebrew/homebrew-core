class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.4.3.tar.gz"
  sha256 "2eda1ae007a567f0d3bee26eea7fcd5745b3e8984a649c7ea276ef6169f67a0f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "359a22f8bad5d10c6d9a595d67934f3f89d0ee2927b449617dd8665500972af7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c66866639d4022a0eb52b09121cebc6f6752f1c787e1aacab1ace40a65f075b"
    sha256 cellar: :any_skip_relocation, monterey:       "891064a148b33dd5f12e79ad5a7813ffcc4883be715bf6d56efdda2776828af1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc792a4f0b8d041e660b2b59115f67c3a9a6f69eefc8b35b7a8a5b72c3549ea9"
    sha256 cellar: :any_skip_relocation, catalina:       "381b7c11875b3a6079a0b738f8571b7150489c48d01f493720f0b4a6c38d44b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7d71fc71a60f55d9b4485e18dd790b562572df83f04cf9aed09ca1c97214be8"
  end

  depends_on "go" => :build
  depends_on "rpm"
  depends_on "xz"

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
