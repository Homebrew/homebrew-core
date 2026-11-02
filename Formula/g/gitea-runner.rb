class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v5.3.0.tar.gz"
  sha256 "b7780dad6d844304960a10083c02eabb80c60bd441232541e1d12e5d2ef6457f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90c7fbc49b992bad913025e754303fdf858de21b55553e0b3f0f46f532a76fcc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "440fee0e69d2c93ec538103432b3d2273eb85271ca203a44978f2964a58ee1b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06d8780bbaadb2a0e966d4b91fa77af475c7b9e1a1f8b64333594c618b2faec5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "420c6decb85e9d6efafc27edce4227eedc12306700cd4392126789c74bb55945"
    sha256 cellar: :any,                 x86_64_linux:      "1d6295a5f87ae4133a09a5161034667750aec82b0698fef4af804ef78b64ec40"
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
