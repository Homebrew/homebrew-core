class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.25.5.tar.gz"
  sha256 "8dad0dc850e753105fa597af483916f9b4e6ca7e27b0418b2ab7580d9ddd7caf"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3991da74d4421b6502af22d9f5f7dfe242aeb37b9371d080169163c3f4acba87"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9f516a9fb32acd9436e1671bb9a695b245c738845e0e0d02ea5d783e9e395a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b7cf0c9ddde79a3546381bcddce91ebb48ab0035edaf6d77536bf6be18c87b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0f7186ea2abf50968745c53f4a8ead39411df6370ece8317fcc7cac3630efce3"
    sha256 cellar: :any,                 x86_64_linux:      "0a25c6859edcb8b96d3fe22e66f491c7998a061261ca2b4d5f9c7e2dc237d563"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "ui", "fetch", "--ignore-scripts"
    system "go", "mod", "download"
  end

  def install
    system "pnpm", "--offline", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
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
