class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "f6a4cb6c74a798e2f3337030d4c7824e8195c8cb54df5d9620f5345f018fc2b6"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949a089b56c2f7e841203cac619c2ac752d7e53d899a05a3962ca9b16670bb0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fe6a4607549de9f4d4db7e671e102f9b2e3acf4c05a60802223e9bf0916c8b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e5666ec4b2d07442d2e0f46abddcc5a8430ae935db9128685e8f2b58c92eda9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c0a6ed3b68d73a2886d8669b759e478424239b13b9d73570963e795146ac20a"
    sha256 cellar: :any_skip_relocation, ventura:       "e5fb58607804eb7debd0bba7f51722f502e00f80266f6f84a1c9deb401647847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a148bcbf2420fa6d6393b257a2230a509b417fe658be3ca4a6c396b3e80e3c3"
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
