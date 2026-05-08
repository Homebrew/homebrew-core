class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v1.0.2.tar.gz"
  sha256 "59f76eca594f0416230c40d5cf569af73ff6daa5998fdf8bb95f7555a6c50a7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feed40cbe9c5b034389e7ddc2fc5054e572640c266ab35d1112bdbb0a85acaf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86dc5f33182a9643a8f95a931f6a5550583d39492d51218fe075d8e7a6dfab62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99f4a5fde67b762b106ea6cdf16d557d186b2a059741765c77a491a7cf33f8f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9011809a51bebc2138f9f0f3aba7fd45731ac79ab7d5ed0142e7cdf53cb967d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e066bd61ef1f178cd730ca2df1d58462f245803e008d41d52f691f7307a72042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8155f4ae2a27bdba043610a9012705569c78e61da8080667f8aef7cadeebc8f2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X gitea.com/gitea/runner/internal/pkg/ver.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gitea-runner", shell_parameter_format: :cobra)

    (buildpath/"config.yaml").write Utils.safe_popen_read(bin/"gitea-runner", "generate-config")
    pkgetc.install "config.yaml"
    # Create working dir for services
    (var/"lib/gitea-runner").mkpath
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
