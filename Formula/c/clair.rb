class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/refs/tags/v4.7.2.tar.gz"
  sha256 "dfeccda372f8298a84a8b4bceebb4fb2f893e77f232e6b5d453db1652d345c78"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "187b08c3ea2875ae55f6b05ad639ea6f7f1ca9c1c891feeef64759b3bf216596"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78e0d3fd902448fb3cd0a5624c6a6a9b41515479008e9d4c5323da494bd0c90a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b97dff3112bd67bee0d68bb538ffac2500e571b35b38d515e74e77f78d980664"
    sha256 cellar: :any_skip_relocation, sonoma:         "99a34cecf0e46eec0ef50d522948bd98fc5af5fe8c8dfe1c31f0746379cc8e5c"
    sha256 cellar: :any_skip_relocation, ventura:        "192594d5cd82870c9978de3e7d573f4b86c63ad6a85e1582fb27e59d4e54035b"
    sha256 cellar: :any_skip_relocation, monterey:       "19557e5444a6ef4bfa2a11ae9c97a69f551303231d3cb63b631987f9e3d0f286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3491976aaa4eec50e3eebd021e898654e4e0e9eb9f305dbabd728e49056afdd8"
  end

  depends_on "go@1.21" => :build # use "go" again when https://github.com/quay/clair/pull/1942 is released

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
