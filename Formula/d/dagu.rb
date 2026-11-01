class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "b0fb8121f28bb98b3f1485d2d8b1922674ea067507b7f2d392c8dad7344820b1"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e28e519a60f5b23d7cceac36be2485b4c3865cd811c7bd197a496161a18d555b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e12317054868e5c8441f33555c8bf150acb421c7522e794e63dacc2187fc305b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a32b94c295aa11eb080833b79636cd2af10a67c97f7b65e671c3ead44b371ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ef6bd9b45a7b8bcc86d2619fe4c2c5ee27f1a6218329c1840063bab9115a4c53"
    sha256 cellar: :any,                 x86_64_linux:      "9a0577f9ba305473825f084657452a85e95c95b9dfcf1dee72fa79e328cdd491"
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
