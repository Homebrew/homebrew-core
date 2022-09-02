class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "0b62ada53c987db4bfcbdc3eecee1ce05c3cf6d19a11e60be215b1b64f4d574d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "652145fc79817c2e9fbf3a765bdad641e486053ce9cfe4ccda58593350255fc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "917481b8b08e6d5a2e1b862a9dff719f9f8c3266c878cf724bd2166fc4dd13b6"
    sha256 cellar: :any_skip_relocation, monterey:       "24101b6f3917e2a8f4cd884d5f0ba0cff7bc6147a49ad75451df733509fab350"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f95fb377a1adfb5ae46bee3e6db1069c45bed1a0e9167436173884736874a2d"
    sha256 cellar: :any_skip_relocation, catalina:       "cb7b22f068cfda1c118dcc5e9c110c643bd07510809759ca1291162a3947a035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893a2b52622b34bb7254469c2deedf23efaa34ed2a0b1678b8b05ebfa35d8b7e"
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
