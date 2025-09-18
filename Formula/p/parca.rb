class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://github.com/parca-dev/parca/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "5f8485d622bfb052a893beec796083d9238595c501eff20508928ac44712881d"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b3d6c3b49e0d76dfb28ab6478cc79546fd02987d1f8dc3c1425c8b221d37df8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dfb07487e2874a72ca29a1eb3ed85e1a7981c560c91119b303e4be05f554a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05f27047351b0582c6f5fb772250541eea7aefe83c356c338ceabf5368ac36f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16ada657b4d2f78fc3315be1739a7d6ac5172c6c5c56be65c53af0014d086397"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1fac35e98d19d1922d942b2801dd6e33872a2162a2a9845eb45b4649359896c"
    sha256 cellar: :any_skip_relocation, ventura:       "0e0dc6dde558aa5baa521c5182d92dbe359afbaf407db05b16811bb7b52e2bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "243125d3d4e13b662a1439f2d9f0a0a482788bc6890645f6a2a24f3076a578f9"
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
