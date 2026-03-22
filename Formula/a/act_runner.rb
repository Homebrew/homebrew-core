class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.3.0.tar.gz"
  sha256 "dc2abcb34e9d0a9b3d7fad1689a659c83277764c080504dc631df4adef489238"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3822ef2af7e75a3ed04cabac772b74689d91e41d42503d69f3eb0334193dd0a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3822ef2af7e75a3ed04cabac772b74689d91e41d42503d69f3eb0334193dd0a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3822ef2af7e75a3ed04cabac772b74689d91e41d42503d69f3eb0334193dd0a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b3b06abcafea1429536cba66342b9cb6fa8b561406c848b32c5f03a623700b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81828824a193041978901d8f68874f65c648f1303fe3c4fa153c254c45de4ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f43b8eb37f9fffdb65a7d2fee6f44c93eb6b53f5184bfca105314b4da96513a"
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
