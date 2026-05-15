class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v1.0.3.tar.gz"
  sha256 "329138043e01348724940676e441e5e8e752662a0184ba106a113ce501db44e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19aa7a1fb7bfdedea3ead40be25e66728f79d37e94ef510b53ce7ce433ece3a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b1a7f289bcbd3078e96745e4b0fa4ba489deba7353958783037ea06752b9d15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a640d61c072e306032a0692b2d331677a101a868e09cfeded437f9187419e91"
    sha256 cellar: :any_skip_relocation, sonoma:        "782474c2f30cbd5b8f07b90a4a901706e9f64c54aa4d17ada3fe35f7461bb2ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1fe22f5179c86e7ade1e164b2ec94a197b0b3cb7af39f61c8adbc8235b83374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dcaf0f20a11d69451f82a9991c7ab20eda11b33798f0186f754a0e3a06ed576"
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
    (var/"lib/gitea-runner").mkpath
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
