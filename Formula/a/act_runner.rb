class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.2.11.tar.gz"
  sha256 "8b317700d1f3344d8664be9edb004914723a4aacc8f8b1b3719ca2260a5866b6"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X gitea.com/gitea/act_runner/internal/pkg/ver.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"act_runner", "completion")
  end

  def post_install
    # Create working dir for services
    (var/"lib/act_runner").mkpath
  end

  def caveats
    <<~EOS
      If you're interested in using the brew services, you'll need to create a config
      file:
        #{pkgetc}/config.yaml

      Specifically, the GITEA_INSTANCE_URL and GITEA_RUNNER_REGISTRATION_TOKEN or
      GITEA_RUNNER_REGISTRATION_TOKEN_FILE environment variables need to be set before
      the service is started for registration to succeed.

      You can generate a baseline configuration with:
        mkdir -p #{pkgetc}
        act_runner generate-config > #{pkgetc}/config.yaml
    EOS
  end

  service do
    run [opt_bin/"act_runner", "daemon", "--config", "#{etc}/act_runner/config.yaml"]
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
