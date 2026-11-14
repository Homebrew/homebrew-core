class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "26c103c3ab10ee3b67d3e9a6245b1bed29f48bc846eb6a1e7ccda393e4568fdd"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe2101b5a738bb9ae5dbc800a03c54870505ae4ce821bc051a20f11c2966e358"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "17604d424e5ae143f5fd65bb30405b11ac2b5923e6f1e3866994496d1c7540d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c100b8395f53bb6e5bd7ecdcaff7edb61dd13d0a89bdbbbbd0046229bf4d863"
    sha256 cellar: :any,                 arm64_linux:       "eab7cc75b51e9a1c3482ca776a267312fa35b546c9d39b51bccc5fdfd568bb01"
    sha256 cellar: :any,                 x86_64_linux:      "4cfbe69111c3f1d6bdf9c929281b38a116bc2601dfdaf64aa9cd979116192326"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  on_linux do
    depends_on "systemd" # for go-systemd (dlopen-ed)
  end

  conflicts_with "alloy-analyzer", because: "both install `alloy` binaries"

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "collector"
    cd "internal/web/ui" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for godror)
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -X github.com/grafana/alloy/internal/build.Branch=HEAD
      -X github.com/grafana/alloy/internal/build.Version=v#{version}
      -X github.com/grafana/alloy/internal/build.BuildUser=#{tap.user}
      -X github.com/grafana/alloy/internal/build.BuildDate=#{time.iso8601}
    ]

    # https://github.com/grafana/alloy/blob/main/tools/make/packaging.mk
    tags = %w[netgo embedalloyui]
    tags << "promtail_journal_enabled" if OS.linux?

    cd "internal/web/ui" do
      system "npm", "--offline", "run", "build"
    end

    system "go", "build", "-C", "collector", *std_go_args(ldflags:, tags:, output: bin/"alloy")

    generate_completions_from_executable(bin/"alloy", "completion")
    pkgetc.mkpath
  end

  def caveats
    "Alloy configuration directory is #{pkgetc}"
  end

  service do
    run [opt_bin/"alloy", "run", "--storage.path=#{var}/lib/grafana-alloy/data", etc/"grafana-alloy"]
    keep_alive true
    log_path var/"log/grafana-alloy.log"
    error_log_path var/"log/grafana-alloy.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/alloy --version")

    port = free_port
    pid = spawn bin/"alloy", "run", "--server.http.listen-addr=127.0.0.1:#{port}", testpath
    sleep 10
    output = shell_output("curl -s 127.0.0.1:#{port}/metrics")
    assert_match "alloy_build_info", output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
