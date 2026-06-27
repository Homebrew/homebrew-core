class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v1.0.8.tar.gz"
  sha256 "9d5b1c79149ecbf8f985f36295e766487cb2e22b0a43f778e276286e0b4cf95a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f08c33e64e94c385154207e3f931667420d124392c13dd29589ad58b3ed1a7c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6786fc030ca8fc7e95c8f0268840863fa7cd7d9976e5ec50fb7ed2d06f829e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeaa464da219a87b5ccbd6001a31383a7f6ee851a4a770a9c7dc1c1753cfd90e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b978f156ecfe7cb6948feefbd4f619f4d3a3fdd88564de6a569038b10fd514e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "393f98826e795d8f92992c5c67423d81e0ddf8c7e357ae744a06b530523a13c9"
    sha256 cellar: :any,                 x86_64_linux:  "2649b7b58b59be0e0814a492f36b0894b2839ee5b14affe5691d7fd75008c3b9"
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
