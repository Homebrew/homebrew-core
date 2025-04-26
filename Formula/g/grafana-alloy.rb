class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "4b997eb53938031177fc7d88dcdf7face053aa752afc5c7416e89739a960c0a1"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b2122a6e221b5cf5e85f43f820380042e98bdfd8825bb257603d7f16f5043f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "901fd08f3b9d6b5135cd34045f150efae190e44071c3a3aad252b663041e5e85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8826ee86c0981494acf0753f6397fc8633f162f7d1a9c7ca95d9ae97c7e3f39e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fd6f20061361816f6602c6781af5ad67e8dc8122dee1ed471d385014cad1088"
    sha256 cellar: :any_skip_relocation, ventura:       "7f8cc3ee934811a0fe7221a8579bba29ce9b2bebe4942e43e718b3ac47ca5e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a42ecc37080513e8b870a6246bfc2dd5970f2b05cc361e13f1057f79a3f12ea4"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" # for go-systemd (dlopen-ed)
  end

  conflicts_with "alloy", because: "both install `alloy` binaries"

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
