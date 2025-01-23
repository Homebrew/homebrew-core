class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://github.com/parca-dev/parca/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "75520fffeed72daa82a4287387380560506ec7ad1f9fb6b54ca6f112f7271686"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a731dff07d7576ff50e07c99a870a59293974a6c0b43bc0837f2e1df7833e9f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a731dff07d7576ff50e07c99a870a59293974a6c0b43bc0837f2e1df7833e9f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a731dff07d7576ff50e07c99a870a59293974a6c0b43bc0837f2e1df7833e9f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "729e2c16c850b5afa8edb50f35133e53c865f514dc24def2757a6f181417b19c"
    sha256 cellar: :any_skip_relocation, ventura:       "729e2c16c850b5afa8edb50f35133e53c865f514dc24def2757a6f181417b19c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9204200ba7fa0ab6dab75950c5da72037e4c9bbead8cbab429657825849c189"
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
