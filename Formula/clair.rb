class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.6.1.tar.gz"
  sha256 "ffb539fb0d891018bb4886087797c3ca1fa17a4b04155ef259fa63f8b08e2150"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4496194a94a51c80fd347155c0904e58e68384ce6d46308572eb19fb375fa257"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4496194a94a51c80fd347155c0904e58e68384ce6d46308572eb19fb375fa257"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4496194a94a51c80fd347155c0904e58e68384ce6d46308572eb19fb375fa257"
    sha256 cellar: :any_skip_relocation, ventura:        "418bd2fc7c0697ad0e166e139cb6887a2f570cf842c3cbee2526ab89765f642b"
    sha256 cellar: :any_skip_relocation, monterey:       "418bd2fc7c0697ad0e166e139cb6887a2f570cf842c3cbee2526ab89765f642b"
    sha256 cellar: :any_skip_relocation, big_sur:        "418bd2fc7c0697ad0e166e139cb6887a2f570cf842c3cbee2526ab89765f642b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed4a3cf6268876826955d4c7d9ecd1089702a678e55b72a7cb04cbdb21adeed"
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
