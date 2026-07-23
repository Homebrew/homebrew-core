class HeadscaleCli < Formula
  desc "CLI for headscale, an open-source implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "8d3c01ca82a07cb26cb5ab29c59e59f9880569702c586961f2e9e8331b65036b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e37c9f94b8f99709e75ddff346a49a9d6220f32a194d65b3092b2f4fe3acf864"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "606a406e3d29d008627117c0fa86db9d95fa3ea7c3720909a3649062d36e36e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f850e4e60f0f72ee5a6ea7f205a1cf4800a47a0282c41967e579dac6fbdf0ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "d052d77910bf4bd98641b3d41fd3b329301bcb19412e642e4b4286bd991c092d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52d9ea6b3be51386d4a34ed7815cb7bbf9e4480aedeeb4fb6c7f43eadd267ae4"
    sha256 cellar: :any,                 x86_64_linux:  "5309138bc1c34fe93a28eb5d24d0dc84d75394e75767d308d70210668efe431c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"headscale"), "./cmd/headscale"

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
