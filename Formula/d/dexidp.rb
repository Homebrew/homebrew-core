class Dexidp < Formula
  desc "OpenID Connect Identity and OAuth 2.0 Provider"
  homepage "https://dexidp.io"
  url "https://github.com/dexidp/dex/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "3c09c0f2be88719d5bc2a061d3df9310052c8220b651a3b72d774eecd9b50b65"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9e4792eeac05a8f0887c058fa1b1f6efd62ef2b0d334cbf3b35772488813b02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "65b71e800fbb494cff6c2cb8609a1d7c102d04a445802559356094873af0ebea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5081d8de58513e9835538590127d8a631cf89db9aadff07f546e1fc471349d7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b70bb8212b19fe11cea13191a3af176f3dfe2d32d7f91a60bb0de9c8b1fa14eb"
    sha256 cellar: :any,                 x86_64_linux:      "850cad36c5c7401a4c3693e7e3b4bf374ddc919053d5316e28cb8bbd2f14f352"
  end

  depends_on "go" => :build

  conflicts_with "dex", because: "both install `dex` binaries"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"dex"), "./cmd/dex"
    pkgetc.install "config.yaml.dist" => "config.yaml"
  end

  service do
    run [opt_bin/"dex", "serve", etc/"dexidp/config.yaml"]
    keep_alive true
    error_log_path var/"log/dex.log"
    log_path var/"log/dex.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dex version")

    port = free_port
    cp pkgetc/"config.yaml", testpath
    inreplace "config.yaml", "5556", port.to_s

    pid = spawn bin/"dex", "serve", "config.yaml"
    sleep 3

    assert_match "Dex", shell_output("curl -s localhost:#{port}/dex")
  ensure
    Process.kill "TERM", pid
  end
end
