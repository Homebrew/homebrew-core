class BigqueryEmulator < Formula
  desc "Emulate a GCP BigQuery server on your local machine"
  homepage "https://github.com/goccy/bigquery-emulator"
  url "https://github.com/goccy/bigquery-emulator/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "e1df04babb193dfc5fb2ec75c6c00e2d2348dc5702128e6f8f4fd4a15c6a1f26"
  license "MIT"
  head "https://github.com/goccy/bigquery-emulator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb07e01d8da2e5e2cc9063396a09b31bca769327e971247bc4e93f2c5ca9a4bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb07e01d8da2e5e2cc9063396a09b31bca769327e971247bc4e93f2c5ca9a4bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb07e01d8da2e5e2cc9063396a09b31bca769327e971247bc4e93f2c5ca9a4bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "086f38cd72ead6fd97faa59194af6b8e1394d323ee86c4003f1c07a81898a73d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c0f6bafcea96fdd93f35b8343c76fe4f309b848b1b5a626958804a5ce8b94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5637b0d0531a6de84579736e7959f129081fa6f485998f8ffbaf1c260491f956"
  end

  depends_on "go" => :build

  uses_from_macos "llvm" => :build

  fails_with :gcc

  def install
    ENV["CGO_ENABLED"] = "0"

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
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?

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
