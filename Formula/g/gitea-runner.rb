class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v5.3.0.tar.gz"
  sha256 "b7780dad6d844304960a10083c02eabb80c60bd441232541e1d12e5d2ef6457f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9311f7ab37902ed19bbe7fa6d86cf151ed1f294162d03b3f2b6435e0de00010"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13e723c9fb95598d9ce513eab29527e4de6dba145509e5de1366fa7814979a6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d21eaa020a905f62c2e30f3eac496492da4fe7b3256731c03c15a0ac82f6413"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "62ff3bb417e8616e68fb47e8f7aa19b463540c300dd1ee95cb47acaa189e5215"
    sha256 cellar: :any,                 x86_64_linux:      "f49db3f1d62db07b95e5ae6e2686579b126e895453ecc6d549f19bb4499b04ff"
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
