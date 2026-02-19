class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "46bad79b5ba502d93c57b4dfe59aadc362cda173290760d8da33080552f53d9a"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d02753a025c492c54a9712085f3504d97e03137ad05414d2d7db67c625a707e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc3c8b839e446f332812712f314a68805a252b3aee3a598cb3a619b9f4d334b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "419a9bd98e561d8f63228e1add91427acff4c2af981ac04ab2ead20ceb99be6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4660cd9a98a80419cb41d823062d2f09339ef4d81bac464d21effcf79b26c8ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a378f18a8391feda2d54abea10eed801dc8786b3415d1ab8d8afefb96f01851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bbf2c0ab5e125d166ca997830664ff79fd80a66573bbb17401b29f50723d7f0"
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
