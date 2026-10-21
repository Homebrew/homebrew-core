class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v5.2.0.tar.gz"
  sha256 "ebf3f24bad167b0e70af9a60b8e8d2fa343b59b588033c3a7040024117f22775"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dcca70f94c497b8b996addb8aa501ecbe97c29b98b2fb37a7fe9bbd3eb90217b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b927b3462da8370d05750bfbbc9c6076228c869d59704d6f50c5399ad4f70045"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "078b8ceef958751efbcdfe919b8f07e1730c19f55a17ca505317681697ab994c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c09c02f14182854b83155cdbc4cbdce77568815e7ae5089a3f23c8eb78d08a74"
    sha256 cellar: :any,                 x86_64_linux:      "92270bb2a60132ea3be6ef9592be85a68734ac4c7f455b65abc7a7c3e4d7c3a5"
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
