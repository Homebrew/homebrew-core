class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.4.1.tar.gz"
  sha256 "b7674aefd6271727d78ec1072634d6b78768f323b74450ab933d525f69a9d2a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd71c9063288d26315b4943663fb2bc9a360cf9fc7f9780681db1aa834c8ac50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4811942b8b373161812c30a3da7354e16c630e246878c2a9d7d5db5ed79c1fd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec4faf2caf9b398f083956beecdf029665472bc27640bf83dcdf2106c1357727"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bb714e226fe9b23212df38c29451aabc16ab943752b4333d7502a0b874e426b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "229ee7ee61133084f72c5e50f93e352a53d80b93943174dec1707d7b9daffd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54f761d21d6e2fa829dbf9d7b7c3e6f5008c9221ec45482778c6115f712fce9f"
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
