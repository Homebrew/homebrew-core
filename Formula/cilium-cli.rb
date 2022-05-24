class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "1cfe549243b97ab781401e34730df6a28ddb31d359b017cc834f8ef1228ffcb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "557573a62242e4b1828e8ed4ac842880a06a22396abde293d0a78f4eb24d6dc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ac365c57a65934b887b1067628f4063b047cf8f4db0a99f4fa4e7eb76ad4227"
    sha256 cellar: :any_skip_relocation, monterey:       "d2e2e0d1ee7b403eff71997a733330230359c187480b1f000921fdc936d415e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "afdfe01ea048a415c9c57c0915bdf37d70a09d1e05c0b58740dce5fd9b424993"
    sha256 cellar: :any_skip_relocation, catalina:       "bd6432d46dd547ca8b9381639d052d2e109b77c225159eb24566da2efbe60436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1092628fdcf9187212bd5a2d851950abf376117dddc66dd15de0f455b632fae"
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
