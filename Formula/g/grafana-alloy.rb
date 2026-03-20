class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://github.com/grafana/alloy/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "63cfffb1c201324fda2526b1764cfdf60913f7f5b878595a986532fbfe12b64f"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb1d4ffade661c2073d779e88c57466c29e0b5c869d54044b245c3471c10a9ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf78c5b90a4eaa04beaef5735f27a1881fb286eb63acf361c7036c8b7aaa012"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1be14df6f0d51c7a7cbaf5abba417a266ce8bdeb025e2524db6060cc6cf5d3fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "840d83841126a3f2ceff20e1f978abb1391ce9d84070051bb29c8e848e2f5f14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae651479fa605d4c1ec619e82dd3b08cd13f9d7b56c864488aaecdaf52d14986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17a656fca1efafcf3d23a9b9ce2a3bc96e664f8f48ad17d07ebbd859c5c50663"
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
