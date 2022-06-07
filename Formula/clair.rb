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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09c3da9a6fa81f1b88b93758e3e14de408ff027faa0be052550d24e12900b322"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30a43c0d8ec8d2fb42eb122b83d2d49b496d03077810e8828f3c0e1e3a4369d6"
    sha256 cellar: :any_skip_relocation, monterey:       "fdfbd0dec39bb61fd3a1a940c46b975f02a0836afd8a66dd60d695b312dee8df"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea1de34957ed5295e307c23498d3047d9424a3b1c6fbcc847a73a5a56f98c484"
    sha256 cellar: :any_skip_relocation, catalina:       "fb2d660844fe2e685eaa5346da9c366fa88700cf2e9a6d2bd3b90f588f102607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c02777f5f234d63673a144ccffa44b0812a05acf632e3450cab49ce4479111a"
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
