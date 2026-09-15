class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.5.0.tar.gz"
  sha256 "1ccc15d71fff570beb91d95dbd746824d29899fc247a3f759640c1758c65a928"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "437ccd550d154ca349c801d75c85dc690f45deb73b9486ff1ffba6e052eb5eb9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a1ea9baa665107d2691cbeaadc0785432ca0daf5cc09112fcdbf1122d1fd337"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b48ea54d8f54e146beb4b66f3266375ed36d938c191609939af455775535ec75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c3f9bdbe53ac07ef81a790ae7e617f3e5a0d74bdbd89debc8bbddd948c54a33"
    sha256 cellar: :any,                 x86_64_linux:      "6f4055e5204e458f39244fba3441e6d7b30823f771d8663b525b2e2c3ca4fdb0"
  end

  depends_on "go" => :build

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
