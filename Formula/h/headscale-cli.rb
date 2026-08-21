class HeadscaleCli < Formula
  desc "CLI for headscale, an open-source implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.29.3.tar.gz"
  sha256 "9c2b6020b51a1d53641fe8e282fd849b4d00eca8945fef93d63454655a90ba0d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6114ea7d64e423dd3d0c6e473b3eb7c9b2a56ad88285550ef68c368074362d12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2636b371992ad4f49f4d3bd76d264a0be9fb24776d5fa20fb07c86cc000bbaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38d32dc36e758fac95495bac999cf6d2bcd00ca3ac2f4aa1e22722c88373ca58"
    sha256 cellar: :any_skip_relocation, sonoma:        "bba4570479819538375c813a51144011d37ec62d4b4b675692cf8b2b8cb8efc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9956734bd49b726d9e6d451b93054b811b7aa8a0c6a645dd43dc4119c42aeb8f"
    sha256 cellar: :any,                 x86_64_linux:  "c246afb358ee76fca8b6a7b115f71087fe42cc78b6ee32ce733e191d77e3cad2"
  end

  depends_on "go" => :build

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
