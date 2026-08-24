class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.3.0.tar.gz"
  sha256 "9c1140d4ef149c674f8344b9945c784b6774c9f2ce1c43647f22eabf4415c4de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "984b1366073ff300d68a759d7450e9b2682d0d6cb658e5709332cd4357f58fdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f231c5c57ffa8221bcbb0e93545b975e47ad6f6920b138b98fda3cf07d22af62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bc74706b6d3bccc3038a42d37a997fc03b5dd6d3a3c238a7c1c644e01da6033"
    sha256 cellar: :any_skip_relocation, sonoma:        "2347b3764942bf71f78d83daddde9b932f1b2e68bc58e01691ebc14438c740de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2ff14d4afe8cac31fcffa4dd34b153b06c8682059628166a02ca1f355e13d09"
    sha256 cellar: :any,                 x86_64_linux:  "ceed2d62a34f447ea94faaa939f73f42e1d1c70c41e53253814779ff82fa0b5f"
  end

  depends_on "go" => :build

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
    assert_match "Error: Failed to register runner", output
  end
end
