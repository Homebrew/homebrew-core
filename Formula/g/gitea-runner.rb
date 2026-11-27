class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v6.1.0.tar.gz"
  sha256 "b44cc601dfdc12393aa8af42c886b5761af71d1d91a43a87d1380f5df24e3031"
  license "MIT"

  bottle do
    manifest_sha256 "0d8b85ea434dce6a6c02c3afae0e3865bfe6b76bf9fcd3b5eb7725940e1deaf9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "407fc5516bd10b62bd3485984e90fd5a2487ea6f3d50f9b5a3c73bcf3c7cbd8c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2515a844877480dc09e66f4be81c23b461f4cab939bc1a9ef4673961b21ea10a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12cf843c8fc1122c702d29a013b72da8707b2668a026dbbad826a55d48735225"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a263157ab5c55e995965e7a4d093ba90ca36fa11b750e7612f5ddb8a8de094f"
    sha256 cellar: :any,                 x86_64_linux:      "0a4deaa64654fb1e1cce583d75bd01be84892fb34be8362db66db33885af3cff"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X gitea.com/gitea/runner/internal/pkg/ver.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gitea-runner", shell_parameter_format: :cobra)

    (buildpath/"config.yaml").write Utils.safe_popen_read(bin/"gitea-runner", "generate-config")
    pkgetc.install "config.yaml"
    # Create working dir for services
  end

  def caveats
    "Config file: #{pkgetc}/config.yaml"
  end

  service do
    run [opt_bin/"gitea-runner", "daemon", "--config", etc/"gitea-runner/config.yaml"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env

    working_dir var/"lib/gitea-runner"
    log_path var/"log/gitea-runner.log"
    error_log_path var/"log/gitea-runner.err"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitea-runner --version")
    args = %w[
      --no-interactive
      --instance https://gitea.com
      --token INVALID_TOKEN
    ]
    output = shell_output("#{bin}/gitea-runner register #{args.join(" ")} 2>&1", 1)
    assert_match "Error: failed to register runner", output
  end
end
