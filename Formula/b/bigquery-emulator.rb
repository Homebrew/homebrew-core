class BigqueryEmulator < Formula
  desc "Emulate a GCP BigQuery server on your local machine"
  homepage "https://github.com/goccy/bigquery-emulator"
  url "https://github.com/goccy/bigquery-emulator/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "a4055b66ad28f972b43b3fe0c7d54a08c57bf91bb4163a39204e152055d54440"
  license "MIT"
  head "https://github.com/goccy/bigquery-emulator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfc703c5f709c8b31f299f4c9781b46f2099e3908984a156ad6ff7b832ad08c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09a97a4d0d2da38a73e8b6bea3fd5957a9e5c2fcf5902845082253969f0b77a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e54fbfc85104d2effc52b84374c4e3c323eb9659ceb3f1aa7c8a7ae8c1283c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "099f43b95cae81557172f860bd1f0771193ade8a8e188a578991e6d8759137b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d392929f5f202cb8cf49912926a283b424941c442071106c0a4bc57d5b7a953"
    sha256 cellar: :any_skip_relocation, ventura:       "4fea8c128986fd389f1441e02bd42aca1a31df8de1a3ce446c63007ce1bb7479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1bb8c6a9605dd3ee04d8e944963aedc8cec753ace951e0bb9d243d4c7271aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b53e2bd32bf44be1c5ad737c1f4058d855faf4b82530aeebdecf5e9e690bdab2"
  end

  depends_on "go" => :build

  uses_from_macos "llvm" => :build

  fails_with :gcc

  def install
    ENV["CGO_ENABLED"] = "1"

    # Workaround to avoid patchelf corruption when cgo is required (for go-zetasql)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bigquery-emulator"
  end

  test do
    # https://github.com/goccy/bigquery-emulator/blob/main/_examples/python/data.yaml
    (testpath/"data.yaml").write <<~YAML
      projects:
      - id: test
        datasets:
          - id: dataset1
            tables:
              - id: table_a
                columns:
                  - name: id
                    type: INTEGER
                  - name: name
                    type: STRING
                  - name: createdAt
                    type: TIMESTAMP
                data:
                  - id: 1
                    name: alice
                    createdAt: "2022-10-21T00:00:00"
                  - id: 2
                    name: bob
                    createdAt: "2022-10-21T00:00:00"
    YAML

    port = free_port
    grpc_port = free_port
    pid = spawn bin/"bigquery-emulator", "--project=test",
                                         "--data-from-yaml=./data.yaml",
                                         "--port=#{port}",
                                         "--grpc-port=#{grpc_port}"
    sleep 5

    query = '{"query": "SELECT name FROM dataset1.table_a WHERE id = 2"}'
    query_url = "http://localhost:#{port}/bigquery/v2/projects/test/queries"
    response = JSON.parse(shell_output("curl -s -X POST -d '#{query}' #{query_url}"))
    assert_equal [{ "f" => [{ "v" => "bob" }] }], response["rows"]

    assert_match "version: #{version} (Homebrew)", shell_output("#{bin}/bigquery-emulator --version")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
