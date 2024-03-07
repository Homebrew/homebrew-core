class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c4c2e5ed223c5c4d8777f1da9b44623373240d940365910adb501636a07faecb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba8adc5048a46c4209fbbf4f1d6d826e26a35c701477f1dca11f38f1f9b9192e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c9d9bbb979b2e1aac348ea4e1e802b1398c2c6f65195b35b1081e04a6be96e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db33b61bdc6eb32c3dc0472bf19c96afb2f5031998657a83d08796aa7fabbf3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fdf69d134e2875e95b55865e0df7cb39d38c70ec211491dbe8fb8b8575ed272"
    sha256 cellar: :any_skip_relocation, ventura:        "1bd13fbc612ac48f3b27bd964216a032824a1010b0f538a0c357f4f585d47da0"
    sha256 cellar: :any_skip_relocation, monterey:       "df63048893140ca767bb308e9833d4043b7ba6191d6c0d2d52ee11cd04f6e2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b02d2abde10854a4dc01ef9de89438039ef519022b40b9f711f7299a75f211d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end
