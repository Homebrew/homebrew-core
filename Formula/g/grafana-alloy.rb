class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "ddda175415f6fae1d941ccd709ec6e41dcc3adf02e9e74a7923ad41fb8e72cf6"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42966e8d056b6e518b7d0c65c48342d20937da680989337c1baa464ee91f1ba0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dce8fe1daabcf78ca2d3fa6be06c7e42f1a4cc6c9f620295a9cbedddb1a28508"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21bc8c52c36db57ffb1a1bca9e24be40f0454a422cf0c896ebd50cd830c13355"
    sha256 cellar: :any_skip_relocation, sonoma:        "e22065bcea365020a476694c7309a0f317241e95042e5738ab3c24485132459c"
    sha256 cellar: :any,                 arm64_linux:   "6d1f9c25be0f7c7faf42f1f8bfe8b2f1490a7c85097a210db313a36ad360c7ce"
    sha256 cellar: :any,                 x86_64_linux:  "3334201a905637e1356630c9aec6c30ddf968d65b04918d117cbf47188ceaeb6"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  on_linux do
    depends_on "systemd" # for go-systemd (dlopen-ed)
  end

  conflicts_with "alloy-analyzer", because: "both install `alloy` binaries"

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for godror)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X github.com/grafana/alloy/internal/build.Branch=HEAD
      -X github.com/grafana/alloy/internal/build.Version=v#{version}
      -X github.com/grafana/alloy/internal/build.BuildUser=#{tap.user}
      -X github.com/grafana/alloy/internal/build.BuildDate=#{time.iso8601}
    ]

    # https://github.com/grafana/alloy/blob/main/tools/make/packaging.mk
    tags = %w[netgo embedalloyui]
    tags << "promtail_journal_enabled" if OS.linux?

    cd "internal/web/ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
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
