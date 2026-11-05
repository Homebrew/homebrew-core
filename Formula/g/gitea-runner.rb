class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v5.4.1.tar.gz"
  sha256 "b5e06ae28b27ec304e4ce2da9c2e51a5be9e1adc9083a1aa1355c8cd2de27bce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6463026f90c51b1c5857639a530ad08b5d02b0ed02b971df559d199540a1451"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "80f11e13927989198b33b3a16bf7ab30ba08056dfd4a4cdbecbba17a15bae5d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b25bac14bdaf3ddb889b1b317e61c70ae2287bc60a945d2523c22c08f4dbf11"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a61e2070658598320e0eac1eb7466257d018c81637cd0fe71e7aee8cd231843"
    sha256 cellar: :any,                 x86_64_linux:      "2bffd16c4765584c0fb3399b893e369bca779e289d564988ab9a6493aa79da1b"
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
