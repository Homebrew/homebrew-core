class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.30.3.tar.gz"
  sha256 "9c04138b957b5f940aa92d7f99495645e7d5b27ea72d0a3de1e8e4063156c4a1"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8316ac5b0c504a24d44bcc4c530de811de50b229e7a806b6172d3041a0e1b619"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf145c797f99b674a5bee6545527b82b7e01907b2506cec9e10b41fbcd0b8d84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11b3ed403b403857a31b3e2304b946d4a3fed758228e8c023f53127716186bb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bce3c02bcb50b0d3c93f012af0dac537e142d087471ea872ff2fe88ac613141"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bd34be5c3227343473f296f063309ef65fe9de64fd4dceb347dc6016de9db07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3fcab29057cf9362799b7b956c6a3297aed3e8549648c70259cb4e84f1e4678"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children
    (buildpath/"internal/service/frontend/assets").install buildpath/"schemas/dag.schema.json"

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
