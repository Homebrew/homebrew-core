class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v5.4.0.tar.gz"
  sha256 "759d24dfc7d0ea212a9305de01c74688f018aeb22cab4cdf2c29f7a3e3108f33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5a75d83d370cdc5e32f39faeba62d6f5442a65e0074853607ca5a0f4b82abbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4179547f9d833ee24156005e1706a2e5a6910e6627d1cdd65219dec2b2fcef83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "416a39baaa23d4b317306f09311054676abd4c75269f9bc6287c38ae39d3a398"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c8cbb34fc5ebf029dfac7215591caacd49ba4a3a8d0d5900309b49b9d987f3f7"
    sha256 cellar: :any,                 x86_64_linux:      "df9336902a85acded804c9d610e9a784913f567e125ad7ed99e371ec26170266"
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
