class HeadscaleCli < Formula
  desc "CLI for headscale, an open-source implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "71a0e83ee94b163868c888c86d829b3adf4975b60e4f1d2706a2dc486ed0f124"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2197df886b2d0c3183a13318601ba4266a21d0191f72cf6525bce09c2a784b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20af5456e80707f1f1b8d4a1b26a831f4064cb3776b32fe0dd2aada097aa824e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1653f4870c604de6c4fa41048dba37e8598ac46ae67b88b453186012666854ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "a910d52bcc16b9ef0e00ff89c68be29a2c29c17ff3bbd3f26005046acdc3c990"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "373a512e6722de27630f8e2b12e98968af1b4afc7457da23b1fe6093e0dd02ef"
    sha256 cellar: :any,                 x86_64_linux:  "2db63462364e70eae7b80e72174f8b9dc353a0f6c81a737b3f6ee52e78e8d28c"
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
