class HeadscaleCli < Formula
  desc "CLI for headscale, an open-source implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.29.7.tar.gz"
  sha256 "625e8f877ddcbacd0936dcd9bb191ea7b8914ef9f653b3e1a3b5fa6c611a36c8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a2ecc389a40101ecd8936a8303c55000624a0ecf176da4f214e437b52f6b544"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13e130655ee047645eb5f9216a4cc051b68cd580dd47be0abd21042e5876ff68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0a5b6330a1ac01277943df914ec1b9ddbfed46e16935eed0ff0162670701470"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d5e7118e9e95788472ce89134092471a575f3e113d884ae6a0f714a58b5d9ccc"
    sha256 cellar: :any,                 x86_64_linux:      "eaa891e155486dce3c92dee7dc21bae7aefbb448363932027a8a075f87027df6"
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
