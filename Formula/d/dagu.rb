class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.29.2.tar.gz"
  sha256 "7a1f650478fefed9e0a959bc199e690deef64ac3b3bc56720fe0932ee2651b78"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c7795dc8f74e10c7aac2619f1fbb06e946184a3984e73e32d3310fd757b30ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71a17ed40ab309c5392ed6d6a767b9e1b6f47ba521d9570a4966309d11d407f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc94704587a7eb4b931be4b7c19853541468caee6427c288fd7594593735334c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b63d1b4080ae4a8bad71a4be431e6efc5ec985d8d2f0a6171863097bf5060e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fbb09b6ec5a2ac0faf250c0967ad8b71040a21b8c9551d2cee3664c8759fef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb66dcb8fe37fd6572c54edf7449a5e80ce9d8276321a899301e70c0f4e13e2f"
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
    assert_match "The DAG completed successfully", shell_output
  end
end
