class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v6.0.1.tar.gz"
  sha256 "302baec8d250021ce518f477f59ca774ca2bd79a27f87143e468dea29ddf9630"
  license "MIT"

  bottle do
    manifest_sha256 "6e2e5703895ae6a4df1b22389c185ecb11401de087a81d87f521aa460cf0c275"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7126e6a3115950fffa0fe3ffd42341bdfe76d7ae406921f41d802e754bdffbaa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cca7419907a2bad78f2b8dd919985ba6b5939ea146a6500a5d4e2f16a1bfca84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cafb085b902cb5e8df387a67e838b1c4e3f50ef89035084da91c7691042a67ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d2c6d684e18bed179b638ee705033c820494f8e7067e68fdb68b5c2ee182f84"
    sha256 cellar: :any,                 x86_64_linux:      "c4876d831710e854ed09f5156b10597879b4adfbde93450344d1716f240e8195"
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
