class HeadscaleCli < Formula
  desc "CLI for headscale, an open-source implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.29.5.tar.gz"
  sha256 "b4ea4abd8b333181906dacc379edceeb3df562aa3d40df086476728fa30e4e8f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "65f19a13226bcaae62ff0745d7c489b41aec6ca9e3e2b31b6afbf4146da95315"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "335f6e0e7734314af92ea38c020716223924f04149819d6e750b933b44ee09e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75f7746688ed007f8a2e567a55a5c55a2691090e4bb5a7e27b6c22e171429ea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "15f51d5b8f2f758f877aae84535ce6c5532f134a8753b47c5db7554d83849029"
    sha256 cellar: :any,                 x86_64_linux:      "600f8b9e9e09444138788911ab07b28da927868ae05a7d7d2ab965156d6c36d9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"headscale"), "./cmd/headscale"

    generate_completions_from_executable(bin/"headscale", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"config.yaml").write <<~YAML
      server_url: http://127.0.0.1:8080
      listen_addr: 127.0.0.1:8080
      grpc_listen_addr: 127.0.0.1:50443
      noise:
        private_key_path: #{testpath}/noise_private.key
      prefixes:
        v4: 100.64.0.0/10
      dns:
        magic_dns: true
        override_local_dns: true
        base_domain: example.com
        nameservers:
          global:
            - 1.1.1.1
            - 1.0.0.1
      database:
        type: sqlite
        sqlite:
          path: #{testpath}/db.sqlite
    YAML

    output = shell_output("#{bin}/headscale configtest --config #{testpath}/config.yaml 2>&1")
    assert_match "no private key file at path, creating...", output

    assert_path_exists testpath/"noise_private.key"
  end
end
