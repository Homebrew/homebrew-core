class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "5e5ca8614c176b0d8d97aa88320472b8505db628677b624fe9457ed3f755d524"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d32d6746975c3b6077589ad1534a371c9a92e54abccbb25467e6e4b6ff1829fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35e3ebe38165c944315436e1fc6b66b5a8ab2eb5001b3edf31671cf995d58a39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "462d0c8a48a505c5e94c27b925f769f0007bdc80c433bd80b92e0f4bb711750a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd6c0faa51a72ad1b7ca5475b7511a6706af7ab240a739cd0909afbb8e283de7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90a323b7fab70302c3e9922f534fb52290068d566be0225f12be4bfda2f32141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4271aab41c5253d9352fa3b4523d5b1dc5b0bf6d38820ca1e4415f5bee145f4a"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "Result: Succeeded", shell_output
  end
end
