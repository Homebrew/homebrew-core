class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://github.com/parca-dev/parca/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "a6e70f0687a583e6dfe5adfac9a05722bdc264c3c6017c54b713d8d57603f170"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fa27fe43d36fbc20c435166dba3a6c9469185c36c9e20662ed2242261cf99fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "990936082e88d67e290dd68c4deabe8128bcf0014801ce6e33acc0cada5c6c99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e57cdf205a217af6f088fc1faf5f9a733b3d4b571f36701545c3b7e7431f365"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c84f3604a5c71a4f7b4563eba865a161d52136587d4b871d481c3585c8f8be1"
    sha256 cellar: :any_skip_relocation, ventura:       "cdc41c2a248ad03df9ce846575b33d78e6bd69f1c329e6220a9e605fb758fffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3325bbd56f7414fb392a234865e50147209c5fc4595e727bb3fe8d06eea558dc"
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
