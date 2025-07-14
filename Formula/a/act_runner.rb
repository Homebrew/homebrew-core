class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.2.12.tar.gz"
  sha256 "69969e1daa846c19dc934e98c811330c8ff88f444e119370ab100861fb3504ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07e84753c5906543b3abee4d105713b8ff0885c022cd2d0999f085df5a06b10e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07e84753c5906543b3abee4d105713b8ff0885c022cd2d0999f085df5a06b10e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07e84753c5906543b3abee4d105713b8ff0885c022cd2d0999f085df5a06b10e"
    sha256 cellar: :any_skip_relocation, sonoma:        "141985c7dba7d4afcddd002eb0d8aeeafc5f7d5abe3a16e7c4686473d9f454f6"
    sha256 cellar: :any_skip_relocation, ventura:       "141985c7dba7d4afcddd002eb0d8aeeafc5f7d5abe3a16e7c4686473d9f454f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38f33478207e72e5c722cfe3a4a222d3b2dcf9d6334f4c74e8c5553601125970"
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
