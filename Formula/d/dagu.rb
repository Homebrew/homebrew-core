class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "e72106d6965e55b50398720775551678ee437f701021b3daf25037664929a171"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9b3ef137f78e8e8855b6e9007908c61b0195e75ff7be6dd2e5c0c5fdfd86b4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd56a98d9682ca745bbfa8294a1b90c641a9a227db5aedb908989009395dd570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "069d9aa037e6e7baaa5da7266db5b0f554824fb175a5c4ab23db9ae1b02a1a3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "273001a4733fcc4f37f6448cf8e8321b73fc0a21d98262053993e57010424e8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63feb5ea8ab5b18ceadb9589b84e963e1068b2a68d8e235006a29eebb79b14ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e00a4808327e0aa7daddbc9a8a9899fd85ca6d04389dd0e039b830e126a43cc5"
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
