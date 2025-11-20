class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "7655e363041181d003216b59d8ab67bb09fd2fa1a7c72c4a40b93f16c53db068"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5c77419597b19bbc760fd3aa57ed1df894b437dcccc19b131390c6a63860df9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6af4bbe3529d3b022cf71db558f24430dd785178ba5432b5294c0ac4e76cbcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af3b9676ddc921271ac04555eafafeb434958d49fa9d8587ace4b4ab70ae0ec5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fedc50869c59a987793db1ef19bb695a0a03dfc7767c6a9eea43ea5090a3dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ee790615443ef88cf5d359e7eb5594b2b57a882766a99da250c234ac9b51c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcc900e5ac70d3ea48b2863a7a7cbd8be850f155508dbb1832dbf3f172be45e9"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

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
