class BigqueryEmulator < Formula
  desc "Emulate a GCP BigQuery server on your local machine"
  homepage "https://github.com/goccy/bigquery-emulator"
  url "https://github.com/goccy/bigquery-emulator/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "b24e327f433ab5da38cc28946ea7cb3eca8c265fa6ab1f428c82c0522d4daefb"
  license "MIT"
  head "https://github.com/goccy/bigquery-emulator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a397c8bc93742701c7799ee2ecddabfec3df714726796fcb4e8e6d61f14d1497"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a397c8bc93742701c7799ee2ecddabfec3df714726796fcb4e8e6d61f14d1497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a397c8bc93742701c7799ee2ecddabfec3df714726796fcb4e8e6d61f14d1497"
    sha256 cellar: :any_skip_relocation, sonoma:        "f37f93ed098640539dfe797b8af9f8426ec20a0a8bb4d55cfa1e860bec5633f7"
    sha256 cellar: :any,                 arm64_linux:   "e471034a6d450e9500fd3042723b98b87e337d2f8fb6c9e5531bb05139002fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff25d427abf1af93767169775f4259745bebc4ec7a23085dc0a1b3bc49bf407f"
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
