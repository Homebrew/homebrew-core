class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "d9eaa0719b9264b47d30ad459d13535d9e51815afcb089245b10eabffb14793c"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fa4ab718ee2c2a349ec18cfc32b64efa61b8c893373c4bf2d4e60865f972b3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2878ce46352a891e0e1403bc2b6ba622fd04bcc8f7c4a11527afe84f6ceb0ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7085ef27a3379c15b020ece45c2b3bd27da7d46c210719f2e917b5df2bfc7f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e699aa684016788397b9f7ec8ceef2cf51c776eb6eec3a8de76af00d1b76cf3b"
    sha256 cellar: :any_skip_relocation, ventura:       "804524c5b40a63fa3c02e08450abecb11a325440959984c1c2dad5f271497b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77707c1e4a40bf5710c5751cea903427946072c2a87fdd25d1bb2b9ab360e6e5"
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
