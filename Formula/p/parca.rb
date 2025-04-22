class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://github.com/parca-dev/parca/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "fb5f0c1778e257cc1dd48e883ce0904535b0be25816b02dc61bc5b054eb822a5"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "803754a46d4237e5be3309e230dd8a180cb367c7efe9b1d42a9b0a2d494fd5d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d411a908e2c433b447a9a8c6bd55999c48da4bc3b556dc97a7b38015077dae5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d411a908e2c433b447a9a8c6bd55999c48da4bc3b556dc97a7b38015077dae5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad7cd30f86b9f6dfa1a1f953830b8cf013b0963fa884087b1062b9c26baed0e6"
    sha256 cellar: :any_skip_relocation, ventura:       "ad7cd30f86b9f6dfa1a1f953830b8cf013b0963fa884087b1062b9c26baed0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d0a6297c3de266f603d6682c3f672ef2bd295876d64f7bfbedaf35399229707"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  # remove unused `@ts-expect-error` directive, upstream pr ref, https://github.com/parca-dev/parca/pull/5518
  patch do
    url "https://github.com/parca-dev/parca/commit/a99156d7a5c8f6a1a42f1f83f7af864cbc11fef8.patch?full_index=1"
    sha256 "01d5f31de779146e333a55f4371f20f39a554d2b9f8e2fe78b9ba747650d14c6"
  end

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
