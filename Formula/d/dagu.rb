class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.16.6.tar.gz"
  sha256 "c7b3cc99a0e35745d1ab6300d686783708bb7d9ea654e682e24134da90e7161b"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f9b8efd973cb3491dd23603341ffcbc26e6114e4ad79985514213219d38eeb6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b792c3a49059b50031f9835eb7856f3e0a2d642ce6a4e3477512e0d503d5959b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c86c4c9a4e9c8e70d58f8c72d1f288a9e0b70686c6c894bec878bd43b069bd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "adf9c04ec9f4838c4a46b8975bf14ae40bab3c4844e64965306d467655adc9ff"
    sha256 cellar: :any,                 x86_64_linux:      "acefadeb1711d54beb74cdda239c0580d1fb4e08e6d4d66ddfd69750a6c95031"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd"
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
