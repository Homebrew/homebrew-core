class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "da0d10e9f8e4a433323f00f757e7b27e4aafce3680db4b3dbda1cfea67338f1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "622ab1a1c9c19d489b4ad023c47c5cd7eee82e58c396f9863c2f938c16d0e3ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20d4a4bf822fce74dc2b77a4aa0e672c4d5c65dc325dd38b146b5f56b5cf8c91"
    sha256 cellar: :any_skip_relocation, monterey:       "f7c9a3cfa1d16133cd0129e897a68d37505b703e2f88c5f00da78b08f7cca2ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e0c379b67e6100e3f248f5850b4fe462c0815cf5bd1cda406096c38fad95271"
    sha256 cellar: :any_skip_relocation, catalina:       "314291ca0d240f241c18471d26b8527f07974f5bf42c7fcf2b48794634b8307d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0acf2004b4e1f20bacdf254555de669c53cd7b88df43bd86e15c445abbf0ba59"
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
