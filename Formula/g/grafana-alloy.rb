class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "879a86c36985e2fdca86d996562cc12cccd281a9a622c9822e5e2836286c5440"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f65156002238ebee8aa82ca63989e934bae4cd43afbe10f8e486599930435322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd5b80c704a06275ec3729ad4a556fee9baa1374452dc6dacd97bb9137ebaf52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "203fbe15bd1f51419b1a273f61492da89b0266239ee8c63cb1294bc36c0bdedf"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fccb634e8bb90648f53f7e7aadd6e64d12543e1c4fc2483b8ba5216091162eb"
    sha256 cellar: :any_skip_relocation, ventura:       "4dd3a04f268ecbb9a0ceea3c6f137e2f546b8f717cc3ee0f1c2abc3d198b6753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d63936181b562e5d016ae350be058d881514ed360ee0452a99d66fb6800144c0"
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
