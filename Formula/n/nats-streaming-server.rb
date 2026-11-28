class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "6f53792784e909870c04441127ca855b6d4cf007ccb93d8884d3278fd23b74cf"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "d29295ea2338a4b0b561d3d57d23221a28e61c7e3f8bc0768264d0ca85b8665f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "998d75b410a50f1dd63b8d9fe6875726fb6e5726cee6a77244b068d87ebf7759"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "998d75b410a50f1dd63b8d9fe6875726fb6e5726cee6a77244b068d87ebf7759"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "998d75b410a50f1dd63b8d9fe6875726fb6e5726cee6a77244b068d87ebf7759"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a84f0ccbca86faaa23e5e3150f2312b5cf547c6c658659d976e485ca75ed43c"
    sha256 cellar: :any,                 x86_64_linux:      "8a6ee554724398d1c5cd551dd2c108c76c6704d0317d673cb250046b8d729748"
  end

  deprecate! date: "2026-02-17", because: :repo_archived
  disable! date: "2027-02-17", because: :repo_archived, replacement_formula: "nats-server" # built-in JetStream

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  service do
    run opt_bin/"nats-streaming-server"
  end

  test do
    port = free_port
    http_port = free_port
    args = %W[
      --port=#{port}
      --http_port=#{http_port}
      --pid=#{testpath}/pid
      --log=#{testpath}/log
    ]
    with_test_process(bin/"nats-streaming-server", *args, signal: "INT") do
      sleep 3
      assert_match "uptime", shell_output("curl localhost:#{http_port}/varz")
      assert_path_exists testpath/"log"
      assert_match version.to_s, (testpath/"log").read
    end
  end
end
