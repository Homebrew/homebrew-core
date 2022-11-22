class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.8.tar.gz"
  sha256 "755110661ffa806ff4129ab820a4297c1d80831401b5947545ec50dfd5e79ba8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f97a065c696bcfef5c189f2a3862b64035bbe0dcba7b3fb41051f636e86d5147"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60c868d2f58cf581354034f3a1f88811aa462c2ee7809456267960fdf8eb27eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cf6f8746e449ad29392440686a3f3fc7be3c91d7923e4d945ce28ed5e59c509"
    sha256 cellar: :any_skip_relocation, monterey:       "6f6696492bf1fa7ae3cf74745f229f60275baa030c6f34bcf6e7a08d67476e62"
    sha256 cellar: :any_skip_relocation, big_sur:        "f77010431a7993d2f735a2e4ba172f1a0f1063246ab6ff4bf4a8bbd68c8483f6"
    sha256 cellar: :any_skip_relocation, catalina:       "d82ef51df8f7cf346d68ddb2c274795cf6ca45b7b5163b840fd54b1465e18c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c89c8f2fc372a116f68779b9e07443882bb7580563266a96b68ece382a6ddb8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
