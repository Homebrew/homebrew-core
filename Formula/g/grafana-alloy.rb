class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "8a4010d3d6e8412b9ddc38537b836bb68dc4370f608ff81a9693c5d4881dcdc7"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf91849ac0d3e974632365d5fec6bda458ad95f011e799fff3daa6052f66bb1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e4cb1e0be508fbaa74ed9d26cd41a555c56810cebb3757ad4bbf9f87acdca54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80026a1a5b3132ddb807e58195316155e17fe9498ac5e2724846bee9c7f7f35d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bcf1b3a9c5b58a68ed769125ba837e7e27a741ccf77e69646f954221c21e971"
    sha256 cellar: :any_skip_relocation, ventura:       "73a3eda855f48faf1ade98f32d816e0cb2479c955a3cac3675357fb01f2506d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4214015968947eb71d6d0f5f50a6362228b0d4799b4b1dd3ff5663fcf87b741"
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
