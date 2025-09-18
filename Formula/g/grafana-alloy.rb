class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "ed170622458600dd335dbdea12cf88a6bee33df1949a58b31a707b1a84f65b0f"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "653457c031f1cacf14cdfa707ddc43c837ac9be12ba00b2fe674375d281f5478"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2b4ab6165f7707cdd45525e7b0be381df947a51d0b71a39829741c5b01cd97b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "351c4e5c78691cec1c41389cc8ad46e6a541b5c51e14b3b67b6dd2c1de5760db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8c2a189bfd46a12a6107253fd846ab49e20ada4eaf7f258306971978abbb73c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca67aea681cec0a714ce96702b474335fc945deac9917b2c34e3b14615de9462"
    sha256 cellar: :any_skip_relocation, ventura:       "c0879a352cc18f178bcbc03a0d1f3cd4086b52eef1ab6abcaa79e90a0e87de12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2f64bccf843986254bd1a47e17de56c707fc7285f4007d0ccaa27ca18bfb41a"
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
