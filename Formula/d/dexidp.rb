class Dexidp < Formula
  desc "OpenID Connect Identity and OAuth 2.0 Provider"
  homepage "https://dexidp.io"
  url "https://github.com/dexidp/dex/archive/refs/tags/v2.46.1.tar.gz"
  sha256 "05e2e149b53f9876269362fefa9061b4b1abd3d5437f23247d79e44a77ac487d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c49941080d7700d092b37d8a0f42d3945495e4f2e8a770f57e011f70870c4c57"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f94f5276080627a13b98d89712e9bfd627bf2e613b0c75ffd289c89c134d372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "515d4e247412bf390427b19817dc46e31700b087e0ea959dec9cec9a5fb6537b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe7c35f968ac055bf0c7afadc2b2aaacaddb9a9efeb9d0e22c78d8e4ce0f31f6"
    sha256 cellar: :any,                 x86_64_linux:      "457e0db33b14cec95d8cd8b64028b408fb2149edd99d1ac891d472d1951ec1bd"
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
