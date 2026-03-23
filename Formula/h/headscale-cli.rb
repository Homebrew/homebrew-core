class HeadscaleCli < Formula
  desc "CLI for headscale, an open-source implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "cb38683998d13d2700df258a81c00add199dccb999b1dacc4491305cdaa67db3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ffb957c9bfde2f1a540934b0eac1b5cd110235afc6e58a4533312655021da1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11c70bd09101790e322bb822dd1769752403cc936441b740c697a95121631b76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "356166fd64fdd3cce34df954c560677180b003338cb625ef363814aaa8bd5214"
    sha256 cellar: :any_skip_relocation, sonoma:        "5698834718f5d740d0b62a61dab7fea00ad22e7933d3b3536def125729cfd4f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abc2c20cf18a262b149af247135da5d287e7db75f1265eec43c6c7d83f547a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea88cc0d6beb9e083bb135c0d2e578e21b4128da64daa2a1f10560e5517fa77b"
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
    assert_match "No private key file at path, creating...", output

    assert_path_exists testpath/"noise_private.key"
  end
end
