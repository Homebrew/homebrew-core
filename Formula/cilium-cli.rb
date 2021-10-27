class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "4d15f3ad07174763e8483f2ede2753ada96604899d1ba990337ac31c919cb550"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43c1f966d2a60c14b75e706fe883b8534c38766ab29c305be7c9483ad5e293de"
    sha256 cellar: :any_skip_relocation, big_sur:       "96350a117038bbcaeebec52c95c804c158576944b349c225ab73caf75a0e73e4"
    sha256 cellar: :any_skip_relocation, catalina:      "948c9222d90ca82c9e036c0ff44a5e5fabc94ddde79996df6839444dbdcaaae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0370dd2166eba59dedb2a51eaa131e4962bc46ad8b6104f07d33ae04154901f5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", "#{bin}/cilium", "./cmd/cilium"

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
