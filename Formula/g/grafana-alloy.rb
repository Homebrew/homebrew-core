class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "e78e58b841730824875345ff496abce3e9df7e423fb64112c95e04e33f2253a9"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "025ca85813021f01740505ff0d04966b05d9832ee9ed69b0a2fea0db837f1e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe614aae07d47725872099716ca29c88aba5492cef28d3603f975c731563bc58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b4a9febb93e67a1bc23229ad095767790dcba955f37bdb2458688ff3428910c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6ac903b25c6a9f4d9dae3afabaf4eeb72fe393f7524d8299be3a6ba4a6f2ac3"
    sha256 cellar: :any_skip_relocation, ventura:       "e7759c5c6092f2011d82cd5b6bf46e6b676fc62ecf8814184b24b05da47df739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ce0e3b1763e6ef65aa7566cb580fca53613ba84fe839f21910473b70c2d1104"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" # for go-systemd (dlopen-ed)
  end

  conflicts_with "alloy-analyzer", because: "both install `alloy` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/alloy/internal/build.Branch=HEAD
      -X github.com/grafana/alloy/internal/build.Version=v#{version}
      -X github.com/grafana/alloy/internal/build.BuildUser=#{tap.user}
      -X github.com/grafana/alloy/internal/build.BuildDate=#{time.iso8601}
    ]

    # https://github.com/grafana/alloy/blob/main/tools/make/packaging.mk
    tags = %w[netgo builtinassets]
    tags << "promtail_journal_enabled" if OS.linux?

    # Build the UI, which is baked into the final binary when the builtinassets
    # tag is set.
    system "yarn", "--cwd", "internal/web/ui"
    system "yarn", "--cwd", "internal/web/ui", "run", "build"

    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"alloy")

    generate_completions_from_executable(bin/"alloy", "completion")
  end

  def post_install
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
