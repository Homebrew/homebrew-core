class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "4040a891616b87d66d6ba0306de4e6199111450eb48e86340044f3bc0e02c81f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa6e358d5e0ba7fc9d2911611457de56162e9c0277e1f94089be768d93f7c4fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb01295e22d3ba7bc97b295aa2b5b044d5a138258fbe97cd8db49420a84e53ec"
    sha256 cellar: :any_skip_relocation, catalina:      "857e9a3bd730c8a77ef84b2620d23037094fbc676fb84e7909cc33b1735da121"
    sha256 cellar: :any_skip_relocation, mojave:        "8e034133cf7c28835c47f50006a07828b237aa53865972c9fcfc1945167724f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3833821cc133c36fa0a98213d30983b3783dbba2d021f7ff48a0c8f51bbdd824"
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
