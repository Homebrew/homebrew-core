class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://github.com/parca-dev/parca/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "62bf0f856f89ed51047ec468005fd695e4ac4a499ff73601f15250e6ee40d641"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "013e81c3488c7873674587696da1a96c74117bfe6054482af72b017fbac58e4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8753efb3daa40735c3894fc645dcfa319118b9c90ae5ccd9c9ebc3729278f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d02a0d2854894ed89815fff65d7fb129f981accdea5b72287f2cc3d29351303"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ebf3ad65142faa07cdc2ea21a035b0bacbc497488406514ae1f278db0ef427b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d5715a616b84334d157f371dbbd80503c321afda66e33a9bf3f6a6a96588b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "744789f3b103028f71511b288dd5dc00c2811c4a17d61977a590ae3a9ece8f23"
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
