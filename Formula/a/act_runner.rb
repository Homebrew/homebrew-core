class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.2.13.tar.gz"
  sha256 "69e6fe36ad9e9be188bf6dfe5fd55697eb92ef1aed6396c9a44c1d8e24611176"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81acfcb35b5d601017eb1c3d8bce6fec649f136ca4fc791e56d2905295bab613"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81acfcb35b5d601017eb1c3d8bce6fec649f136ca4fc791e56d2905295bab613"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81acfcb35b5d601017eb1c3d8bce6fec649f136ca4fc791e56d2905295bab613"
    sha256 cellar: :any_skip_relocation, sonoma:        "5229fa2af00fec17c952f11718551e4b78c26bf29da4bd53c786fac7259c7438"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16298df23af4bdfc0c69f5c393cbdd5949ae89c7016c9da5a17ba1ee33628a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7666bc1cdfb2b61a1be3c0346b8aa7c2d50bf193bd52432db0aadf00f3e9125"
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
