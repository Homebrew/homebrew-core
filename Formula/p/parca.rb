class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://github.com/parca-dev/parca/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "61ca1b92fe77547542c0b4908ad8f295ddcde409ce48e5133dbfefd468d44bd7"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45144223430f1492038f5beefa82d4a91ec689dbc27184560a00b0fe1f0ac857"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75ccceb6c07caf0bfbea5b3c61044e4701e7c26506cf37a077ea10629eef8e28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23d66e63f439665d1c5c64092dc763a9b64732b16b047b53deb3c038ae0dc481"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "95b0c961c3d62a850b3c9c94f29aebfa4c413e652ba9990cb4fccc52c17b678e"
    sha256 cellar: :any,                 x86_64_linux:      "2ddb230e0eb6060fef9012fedd1136e3c67ab1136bd135543b1b6228d96f666f"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"

    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/parca"
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
