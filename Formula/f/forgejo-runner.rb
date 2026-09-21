class ForgejoRunner < Formula
  desc "Official Actions runner for Forgejo instances"
  homepage "https://code.forgejo.org/forgejo/runner"
  url "https://code.forgejo.org/forgejo/runner/archive/v13.2.0.tar.gz"
  sha256 "9a7cc5bce2385feaa124213a7e000090dfac6e6a0177b04ae084e7dcb6ba46d5"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://code.forgejo.org/api/v1/repos/forgejo/runner/releases/latest"
    strategy :json do |json|
      json["tag_name"]&.delete("v")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c8b9bd534ab0b380cd5e34186088964740b63ef9a7d2c450a42eedfe20a54d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c8b9bd534ab0b380cd5e34186088964740b63ef9a7d2c450a42eedfe20a54d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c8b9bd534ab0b380cd5e34186088964740b63ef9a7d2c450a42eedfe20a54d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2992055ca9c45ffb38dc027b258e3fb401dd77d31d0da72d09d4db6c966e4a08"
    sha256 cellar: :any,                 x86_64_linux:      "2b980c34f907a83cec7609c412c182c731718dfc66554b2f448a33ba49a60f6a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X code.forgejo.org/forgejo/runner/v#{version.major}/internal/pkg/ver.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"forgejo-runner", shell_parameter_format: :cobra)

    (buildpath/"config.yaml").write Utils.safe_popen_read(bin/"forgejo-runner", "generate-config")
    pkgetc.install "config.yaml"
  end

  def caveats
    "Config file: #{pkgetc}/config.yaml"
  end

  service do
    run [opt_bin/"forgejo-runner", "daemon", "--config", etc/"forgejo-runner/config.yaml"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env

    working_dir var/"lib/forgejo-runner"
    log_path var/"log/forgejo-runner.log"
    error_log_path var/"log/forgejo-runner.err"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forgejo-runner --version")
    output = shell_output("#{bin}/forgejo-runner generate-config")
    assert_match "container:", output
  end
end
