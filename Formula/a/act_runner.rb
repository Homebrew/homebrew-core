class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.2.13.tar.gz"
  sha256 "69e6fe36ad9e9be188bf6dfe5fd55697eb92ef1aed6396c9a44c1d8e24611176"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3283c0d05e2583594f90c1430b16e99451e172d385475f138efa139e764c195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3283c0d05e2583594f90c1430b16e99451e172d385475f138efa139e764c195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3283c0d05e2583594f90c1430b16e99451e172d385475f138efa139e764c195"
    sha256 cellar: :any_skip_relocation, sonoma:        "16bdbacd7f86a3ada3040c12a1f5db4aec0abae7f5467d52e8e38f8d26ca8af8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c57b15b24a7b4719926061d95b3840e42b07202a27cbcf284607acadc0dc6c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bb584490a65e01c487c833f9b3778c804b82599893c06e53e3335e9f854a861"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X gitea.com/gitea/act_runner/internal/pkg/ver.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"act_runner", "completion")

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
