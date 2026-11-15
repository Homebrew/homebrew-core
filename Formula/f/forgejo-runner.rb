class ForgejoRunner < Formula
  desc "Official Actions runner for Forgejo instances"
  homepage "https://code.forgejo.org/forgejo/runner"
  url "https://code.forgejo.org/forgejo/runner/archive/v13.2.1.tar.gz"
  sha256 "c5596ecdf5336b5c4777109a373ba675130324104618ce34952f28682a44c948"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://code.forgejo.org/api/v1/repos/forgejo/runner/releases/latest"
    strategy :json do |json|
      json["tag_name"]&.delete("v")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a8cb32f024121e50ebca1840ed2f5650d65d3eb3e183679c0f8f0bc14d6fb48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a8cb32f024121e50ebca1840ed2f5650d65d3eb3e183679c0f8f0bc14d6fb48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a8cb32f024121e50ebca1840ed2f5650d65d3eb3e183679c0f8f0bc14d6fb48"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "46b6cf6d9a7ab413cb885271f1e1e175a3794cf289a77799f5de65e2e216019a"
    sha256 cellar: :any,                 x86_64_linux:      "86f9ca5c0565e96a989987cc6ad01043610287fdb13d30861be4fcbccf37f974"
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
