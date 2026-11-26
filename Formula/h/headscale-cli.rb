class HeadscaleCli < Formula
  desc "CLI for headscale, an open-source implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.29.8.tar.gz"
  sha256 "77dcadd5e9f6620a20152508af38d65e61aef2c9977bdc031d76db3355e54300"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "fb7a12179b2e7b6054b343c323ee6e3cbf1eb599f4d68d3c657fc87bcb0c6425"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d1dcf1460c0080350ff31f767d89a3a33cbe614334c724cf6f59173b53f171a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3652852edbe58f70d8f852041291406f144bbe615b7c89e0e38cdf277aaeb12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5be05454fba2ead90d0e8bb010ba9bb798545163af6d113d55ca22da692675be"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2e0f186ad785934df6e6261fad79b9ef7e7c04190c619462537be79a27fe21f7"
    sha256 cellar: :any,                 x86_64_linux:      "ec8d118830b7b50a9644bda43beb805d37f1b9a5c84ada1e340ee41fea99b081"
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
