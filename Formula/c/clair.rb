class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/refs/tags/v4.7.4.tar.gz"
  sha256 "1c90235a76015a882f547c298e713526b93425a02fc7f02566fa324dc237d6c0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4dd2ce5f51c312e3c330c4abd4294f86914c10301de0b2c0e2bae0937b03b833"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "915eee0782e5b51a6a7ba29787f2634f943bf35d811eb96f031986422987acee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b18882823c8aec9ac677cdee87b5a21dca1b5b313cbd3ffe8e5dfb20caf5747"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b15529ba82bb3cbcb43fb3ca328d3ed5c8f69d6fe942a69e007e1145696f4b1"
    sha256 cellar: :any_skip_relocation, ventura:        "9a13cd998916f00222a0664e7f2e6b9df514c554ece3b14cc42390d7cbc84da5"
    sha256 cellar: :any_skip_relocation, monterey:       "98dcf56b8e81c12c5cf94967dc5bd4a3e587b9d36974264a304ef78585f17f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dd538221ff3cbefec3bc0320d76d06efc4471fbdf8694d696535640fde60b57"
  end

  depends_on "go@1.21" => :build # use "go" again when https://github.com/quay/clair/pull/1942 is released

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/clair"
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
