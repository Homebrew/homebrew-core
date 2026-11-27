class ForgejoRunner < Formula
  desc "Official Actions runner for Forgejo instances"
  homepage "https://code.forgejo.org/forgejo/runner"
  url "https://code.forgejo.org/forgejo/runner/archive/v13.2.2.tar.gz"
  sha256 "81af58eeba53154c7d69f1ecf4501d7d04cf61b3d4fe31373f5e74fd7ea2a927"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://code.forgejo.org/api/v1/repos/forgejo/runner/releases/latest"
    strategy :json do |json|
      json["tag_name"]&.delete("v")
    end
  end

  bottle do
    manifest_sha256 "3490412cb2e2fb0d194292d95f3b007ce57654bf374b7cbdf11684f457e81bcb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1860fe99270ae4e65eb11b24ca4c92f4796080a007feb396b6dd9f502249fc64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1860fe99270ae4e65eb11b24ca4c92f4796080a007feb396b6dd9f502249fc64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1860fe99270ae4e65eb11b24ca4c92f4796080a007feb396b6dd9f502249fc64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bc3e81d62cb68390acd3800abe3aaf1b8bf570cd69264c837da3d81a3d492f87"
    sha256 cellar: :any,                 x86_64_linux:      "aba078b4c743d6869dffd37b11cd0492daeb50b9c3fa8758a858711cb5a13307"
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
