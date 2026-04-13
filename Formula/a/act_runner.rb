class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.3.1.tar.gz"
  sha256 "d81832995fc86b73e415752d1f15dab698cda96213bd6573f303c112da5c722b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b4a2a72a212a839b6986c88d7668b28fee97eabe1fa45242926229e1f0e1513"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b4a2a72a212a839b6986c88d7668b28fee97eabe1fa45242926229e1f0e1513"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b4a2a72a212a839b6986c88d7668b28fee97eabe1fa45242926229e1f0e1513"
    sha256 cellar: :any_skip_relocation, sonoma:        "920e8c0dd838b2f9ce5ce9341be70192db836333d04485425ac8ed19432bdd3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "914cbb18e132b1fd3e39f90e608484468ce2f02e46f318ac6579645498b00738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38435d2631a2272dd3ab7ddbb2f5c6cdf95b24f4a929a9769844a9a753b8dbb7"
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
