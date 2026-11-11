class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v6.0.0.tar.gz"
  sha256 "563cdba528c213114c8d00f3b34d049f10049f288ef9f4e0e6d1b6946343d498"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0aae651d51caad8f3fd22dd96c185f8e55ab8a9681fb2ba31fe1a3523d3e174"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a18fba935f8dc63a4b5abe07cccf1196f2efb5835821e3f0dfcfa157f7cd6e53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "419430a8fd8f0b696a0243e06ead9d5bf4c7413127d2fe06a35c6e3fcf8a4d6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9a150de842ac7c3a65e2484c7c9801ea84e755fc423d180cc5cea515e934193"
    sha256 cellar: :any,                 x86_64_linux:      "e0af7cc99a08eb89303bacfe07cb2ef4669eb47157b0d31f8af6091314f63119"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X gitea.com/gitea/runner/internal/pkg/ver.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gitea-runner", shell_parameter_format: :cobra)

    (buildpath/"config.yaml").write Utils.safe_popen_read(bin/"gitea-runner", "generate-config")
    pkgetc.install "config.yaml"
    # Create working dir for services
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
    assert_match "Error: failed to register runner", output
  end
end
