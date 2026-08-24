class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "12750e16bc6343d80a12636f2a9e819de30e53916af1f12ac2581ae6fb011257"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f0117f0512f2ac2720aecc2d67c4a7e8dd6e064465a896e7e91614790402acb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29af47b60836e6816f39b3f69f72bd518dcd95e91ea42398f85610fce85afb0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04038eb50592313c65b2c32d51f7b0bdbd907dfec8ad323d5ed1aec368cec12a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a47042ac0ccb3d3c50110a8f64bd7d719e35dc0e9a8afc3fea2c856fcf940ca"
    sha256 cellar: :any,                 arm64_linux:   "99b798efbc42370d33994f86d7f9a26252da7546abda662bd45808e7b8a7d5fa"
    sha256 cellar: :any,                 x86_64_linux:  "58e45c828188d236573eaa84828e7bc224ceb6465361fde3ebb6dc81b0016915"
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
