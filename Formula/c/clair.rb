class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.7.1.tar.gz"
  sha256 "476cabaf9c0afe276648e33bcabeb4fb753c8dbfdf9f8e0d6d3cfe2126d06cb1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d13a2ff8953622339570da184eb135f35661f3b12fe8f85401816a9ccc69a3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d13a2ff8953622339570da184eb135f35661f3b12fe8f85401816a9ccc69a3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d13a2ff8953622339570da184eb135f35661f3b12fe8f85401816a9ccc69a3a"
    sha256 cellar: :any_skip_relocation, ventura:        "b5677134198c2f8a4140cbe6da17df0783765ab60a0b75aac9451a67139d5d52"
    sha256 cellar: :any_skip_relocation, monterey:       "b5677134198c2f8a4140cbe6da17df0783765ab60a0b75aac9451a67139d5d52"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5677134198c2f8a4140cbe6da17df0783765ab60a0b75aac9451a67139d5d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99f2cf77b1475c95bceb8ab44c12f25c0d5ced753f0d78bcb43fe2eaabe6b8cb"
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
