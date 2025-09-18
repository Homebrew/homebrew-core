class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.2.13.tar.gz"
  sha256 "69e6fe36ad9e9be188bf6dfe5fd55697eb92ef1aed6396c9a44c1d8e24611176"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a0cfa9e0ffbab45375a67c81cc5ce165fdfc99317724052adfaa8b11e20c531"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e525763dffbc8e994cb4d45a953a9831c2a55157c0f69594a756f8c430ce91d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e525763dffbc8e994cb4d45a953a9831c2a55157c0f69594a756f8c430ce91d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e525763dffbc8e994cb4d45a953a9831c2a55157c0f69594a756f8c430ce91d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8180d78844d19ff451c313ecc30965cd7f0a7c5c8fdb5fcee54a95bfd2ed719f"
    sha256 cellar: :any_skip_relocation, ventura:       "8180d78844d19ff451c313ecc30965cd7f0a7c5c8fdb5fcee54a95bfd2ed719f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716c0ddb4c00ee04e35141a73c50b74aeecaaa17b9504a5537f1794927f11cce"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X gitea.com/gitea/act_runner/internal/pkg/ver.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"act_runner", "completion")

    pkgetc.mkpath
    (pkgetc/"config.yaml").write Utils.safe_popen_read(bin/"act_runner", "generate-config")
  end

  def post_install
    # Create working dir for services
    (var/"lib/act_runner").mkpath
  end

  def caveats
    <<~EOS
      Config file: #{pkgetc}/config.yaml
    EOS
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
