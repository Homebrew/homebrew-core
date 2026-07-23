class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v2.2.0.tar.gz"
  sha256 "0a0223acbce5828f8626e1c632ac7e8f3786337426dfad35712cab38c7ccbf0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83188491b526b6bf15b0c4835f0ad3abecf48942b6d1146c8c73b55901106fa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4512f6a84d41adc450f4d9cdc0c774824fe497262b8f594fcf5e61accdcef382"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5abd08aa296596e94649435c8af07b117d4b4128f185c4499c2a1739df70423c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2681d3141cfed2fd5d6e7e9383fa633913f8e14d2e8620f8aec95847599e78c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a52dab53d87ca39b7eeecddeab31afe079126e3545fdb409fd3d454982c2b6c9"
    sha256 cellar: :any,                 x86_64_linux:  "2a10a8679b952aecbf90f0153bda4351fce96e24bccacb8b486a5bc9359cb7a6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X gitea.com/gitea/runner/internal/pkg/ver.version=v#{version}
    ]
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
    assert_match "Error: Failed to register runner", output
  end
end
