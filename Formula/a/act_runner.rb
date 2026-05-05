class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v1.0.0.tar.gz"
  sha256 "6fd62bda86b7775048feab134eec4d6d4fea0f08141fbc2c9526f43402247f38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02f3cafce73239486226e18d18036a2ef0a6358208397186d43248438e8bac7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d01904c7988839520e613490d8a1dba70b66276161925f398ae19bffb994e29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c16ba49bbeaf460bfd4e116206a6403d0549328693a23dc47c0e85e69b8b847a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5706675096a4891702deea5d41e83b5295d1a93f27886a85e6b93076d879a83d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ae831004d38e43577716e27b37e1c3d32be069d6eafff6b4f1771facecaa4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a23cde4515a4f05c3749e0933930cc76dbe8a3c1a0e880e21c964964dd35ba2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X gitea.com/gitea/act_runner/internal/pkg/ver.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"act_runner", shell_parameter_format: :cobra)

    (buildpath/"config.yaml").write Utils.safe_popen_read(bin/"act_runner", "generate-config")
    pkgetc.install "config.yaml"
    # Create working dir for services
    (var/"lib/act_runner").mkpath
  end

  def caveats
    "Config file: #{pkgetc}/config.yaml"
  end

  service do
    run [opt_bin/"act_runner", "daemon", "--config", etc/"act_runner/config.yaml"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env

    working_dir var/"lib/act_runner"
    log_path var/"log/act_runner.log"
    error_log_path var/"log/act_runner.err"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/act_runner --version")
    args = %w[
      --no-interactive
      --instance https://gitea.com
      --token INVALID_TOKEN
    ]
    output = shell_output("#{bin}/act_runner register #{args.join(" ")} 2>&1", 1)
    assert_match "Error: Failed to register runner", output
  end
end
