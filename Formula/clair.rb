class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.5.0.tar.gz"
  sha256 "dae23123df0180960263531ad22e6e6eb683a276c4e8e7c67e6792b4b58bad65"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36353c524900ebcca7fb3324e14d01ab662a40d1cc0a47bdbb69cd226d3185bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2d06c88e2b9e21888cded7b3d4e2e2ccbdd43ae02b38655d071dfe929572cbe"
    sha256 cellar: :any_skip_relocation, monterey:       "d29b85094de70d4b034081f32b5edf893fa1e950663b2b31a3e84584316a6798"
    sha256 cellar: :any_skip_relocation, big_sur:        "fae5f403b4459e45e5e50edcb1e270f82dbdf18c5b445d52a2aa37b58085d3a4"
    sha256 cellar: :any_skip_relocation, catalina:       "551e4703b1b444b141e9b9a9745c4b49554ce9482162e1253a175c75f8ad5ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02ecbeaa9fefbd0cb3a9dd8b52da6cf9aaede27ba530d3da808bdf9ca3ef48d3"
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
