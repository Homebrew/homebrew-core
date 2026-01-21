class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://github.com/parca-dev/parca/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "7c7ad9a3c41ad1c81d74f20e07b36703c458fff649fc1d0dfdae4b3f4cd1f56c"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f330bafcd9330e32210c7eba0898c0b71a39e4ebf58f1c711132c98c87ecc02e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e26a4572994fb56b4902b4df124b5166970add4396b01e436fb9aa28f4fdbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac0a18edb90484be757f362bf061f82eee46f556466a71838313089ac3a65a70"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6fda46d74ff7ca16f6c0e526e3b13e58f2789fdd33d295fdc52296a42320605"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d94e5506cbbe29dc38ed4f22c65db25742a7ab35b05687c44d10d1963388e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e489644ebc57c549f12202bdae742de0fccb10e82a4c92030a61e2062fb6268"
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
