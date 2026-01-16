class HeadscaleCli < Formula
  desc "CLI for headscale, an open-source implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "a2ba09811919e4b285d17e4cdaf7ed5aeb9a8567eda11119557436d59711632e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e15061b3c727bc860a859da8491403b6e1fcacd6514232591a19d075f0ff396a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3305a23e2fdc6012550b660c2b6980b40ff2480ede1b67c36f08ae14ca5fec43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d71db25739ea4295686553e4593bc85cc95286ee7f654c4d3fa462543f96d5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f02885e6e6199593b9160501f53e64fad91598dd691fd4b10858f41bc24acb42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08ba60d1591482052e607b8483e59561eeed8fcb5c1b9ebe90f755aab9515fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e24da24a3c45a44d2c6c2f7386c222a6685785635c7ba2ea1bec5675ad319bd4"
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
    assert_match "Schema recreation completed successfully", output

    assert_path_exists testpath/"noise_private.key"
  end
end
