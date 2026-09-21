class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "3906c641ccfa03ad2ff777618c13ca3a0ee8417f995d192b5912d310aa5a34a4"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d389210537ee450e0608866af1327b6ff757e69d4c290dd9184a51d0836e972"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "129bd2ac4a2490c75daf16f158b2e20eee190e467b8512361f85afc218c67a74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b930361f022e115483b0a0648a7811e14e1301d97ff7d295a3086a261e708468"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "473289a03a7b5f8e874a262ae7369e81982e980539cfacc628d380562f1f81c0"
    sha256 cellar: :any_skip_relocation, sonoma:            "3fd4efacf9cf10fbe6dfc9ef3a1d77fdcb801147aef7b0ff4a632d4e0d7f431b"
    sha256 cellar: :any,                 arm64_linux:       "da08511ff740cc2742b7c6f37df769840d58173312a103a0071cb4ddd2017009"
    sha256 cellar: :any,                 x86_64_linux:      "a8324ee08b3e3c0d066c2500bbf91dc66a8b173e124cc1a7cff17127d699ecca"
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
