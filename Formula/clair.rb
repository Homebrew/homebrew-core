class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.6.0.tar.gz"
  sha256 "211c0523e19e4964a64492385537864e5e8284a38a1b798d20a535b643d4987f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "711004d1d271070a5500856ed5ff32fab9e4f5f9ca3dbaf03e3a0a2fea2935e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaa9ffb4e4ff24fbb472a605b865d8aaef5af874f1e93bee2d9715574024c170"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e8bbe51bca992633c73e01b1b1605081810c165c4560e4c31fcfc211b09b3a2"
    sha256 cellar: :any_skip_relocation, ventura:        "c5d9487f9a0eb603babf8de6ae735fd4b0c78836559dd6e24244a3715e64c9fc"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2ccaaafd00a59baa2c4b8ae982044977f9e9e039e1b67d34e75a18db5c7927"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3b2e82c8a4ea869cef700eeb1414843b1494c129d83b8d7ab69b434684fda0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74a376b9cc5c54c2c2451bd12c02817b5823642368d374ea0b8a107ac8e8f176"
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
