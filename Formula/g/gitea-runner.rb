class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner.git",
      tag:      "v2.0.0",
      revision: "b7f6b6d90a181d3f78db88c6a44e77bc39786993"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a71bb9d326e588f67d43ea41fd32e61aaca91f0233d1a9ec1b81cc6bd5086da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a9db9e769414682299bfcdc207f7e193fe1e396e17be0f2394cfe6ac243c48f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61dea1fd2a4c7c8be7cbf674d41caff8d6eb4919dc5a4114a708530fc2bd6f43"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f46e051b1634f3dc39f6c350f86c9ebe8972aebdc04bc2ca7acce294c84eb9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e4b8f1cbccd072633a7644e525f9e8a98aa61b78fef34fa8fd12bc41bdfd2d4"
    sha256 cellar: :any,                 x86_64_linux:  "4f873cb784e6fcbbc3fe4097fe4990c9746dc9f1051ea6ecadb398c9798f60b7"
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
