class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://github.com/parca-dev/parca/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "8db291778d7ef1eed8d69fad6c640970cd5a2b901ecdbd8041f3dc0817d6991e"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "444ca30f5001ba44cde28eee198e4a8caffb61b8d436756b15ca94e29cf7853b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa1854bf735ff49318694ea473f75d5cf98f3b16f96a360113e6a8d228b87a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd445b28683b8d66b6129af652859f45afd16581c5e684975eac67819fb1eea4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eb1eaaf6047c4403e8529ede8c3e9fd51ce23bebfb935173d40fef994a23756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49e01bc5b0ebe871eeaccf7d3bc3424a3b8d897d4545d8b62a85a61818dd960f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d82e2a78abd1930274e94f5a5ffaf76065f2e5d8e5e0fee8607aae8006b64c0e"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/parca"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parca --version")

    # server config, https://raw.githubusercontent.com/parca-dev/parca/cbfa19e032ee51fccd6ca9a5842129faeb27c106/parca.yaml
    (testpath/"parca.yaml").write <<~YAML
      object_storage:
        bucket:
          type: "FILESYSTEM"
          config:
            directory: "./data"
    YAML

    output_log = testpath/"output.log"
    pid = spawn bin/"parca", "--config-path=parca.yaml", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "starting server", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
