class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "519de87a41d6b12a9377361e0d49c62bb07c3d7fbbb1c0a0e12810599bfca2f5"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bedd8bf009665c2aab4fcca8e54eea3def6138968eb069a70a30440cca5a813f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65ccfb8c0f08ed57c940446fb7a06dbd3cf86b0e8fde3351b4210717ad7e322c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a43bc93e76d46e37836dbc0b6cfde2cbdac96e66fde7739424afac4077cdae26"
    sha256 cellar: :any_skip_relocation, sonoma:        "3693adabb6cf205a6589eaafb1257e3de2ab0d74055684cefd95ae4097400314"
    sha256 cellar: :any,                 arm64_linux:   "de7d99aefb8db408bcf3867a86bfe4bea437d210aa078eddcb9a67d4935c9648"
    sha256 cellar: :any,                 x86_64_linux:  "c11b53aeb0fe97467f9b3099e36e907e8d636ec3eaaed07200cf592d2fff555c"
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
