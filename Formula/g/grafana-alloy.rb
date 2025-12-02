class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "7655e363041181d003216b59d8ab67bb09fd2fa1a7c72c4a40b93f16c53db068"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "365c67540b74d47af157a1872fbd3dd32835a6d3129a1975f2baf27f893fa4ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "729b78699b54b47d4bf7da24a1dfef21c9e00149ab9bbbe7877d3e64d247385b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58dc3086cae2c6b44fd79fa18b453c83cead2058d8e9a29ab563e799a8aa6486"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8d4bf8e6c7149f75dd4cd4514fb2697833741c43148f548223cfb83331698b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2928eb8330d8d970c5344052db7a901e1b15e6a8d76441426deed2c9b1bc8896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2c0edae45a006c469b14f3752b4055c61709b286f0eeee78cbba3972d8b5aee"
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
