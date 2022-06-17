class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.9.tar.gz"
  sha256 "36bf52af9f18a6265de4673ace26815c1d61fcf437590f668cce26a311afa181"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03c211edc90bea7ad3889953d8cd9df5960de6e82346cb76cb0c41e33c9df4d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7b893f0e38647723b04e298c3e269177e57bc31151e8368069b03d2f3d502b9"
    sha256 cellar: :any_skip_relocation, monterey:       "bad48af4eb31b9ea02b78d3301a5871f0f3baae2986d690ae5162b018b8a4712"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c883323afe04421a4907dfb738d6e5b7e228a7b09b6aad5cf4adbde7603cb75"
    sha256 cellar: :any_skip_relocation, catalina:       "3fbceaba779633db7a78976770066ac4cfd6c4c6a5dd06d8720b2a964d4fe62a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01e7ec51869803cb66bfde946e2944174d51d8ae07384dc8a307c981ef9b55fa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    bash_output = Utils.safe_popen_read(bin/"cilium", "completion", "bash")
    (bash_completion/"cilium").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"cilium", "completion", "zsh")
    (zsh_completion/"_cilium").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"cilium", "completion", "fish")
    (fish_completion/"cilium.fish").write fish_output
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
