class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "c009fe9bbb65cd118b678ea4e4aeca8fefe15669bd20f5a1b57222e622d79952"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0c8eae8a1d6bfc972f11e82cf0e3038e746f877192df3769c191542ad701e8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47db50265bd84a60fae9942f63f485bbc4e2f3c4932c6919b1baefa20f913404"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e545319296ae93e55023140041adf18e7ad1ad49b1bce66afc33fd9bab160e1"
    sha256 cellar: :any_skip_relocation, ventura:        "b258b791ed5e2ce043fffede06815510741c0497f37a9a08c292b91cec48cf83"
    sha256 cellar: :any_skip_relocation, monterey:       "76de2111f5529e506ce9f325ea9df531a8f4a5d049cc5944c5192fa1cd076eda"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b33053d66879fd8140fbfab57dde44b0de8ab8e21198eba2d0b886c0cd9fd2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee531f54751862e04919f042de09624fab6a5e571ac21437afa2c5d5124d50c4"
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
