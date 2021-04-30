class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.0.4",
      revision: "b3302b318c7f123a048aeb9c69d693980df3fe72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9aeba70b047c2376299a47b6b179744d7efc2572a06c66fb8130cec648478fa"
    sha256 cellar: :any_skip_relocation, big_sur:       "3113da9dd780e5401af3aec31094c432e858d7e4184d47d1b66bea20506ccdaf"
    sha256 cellar: :any_skip_relocation, catalina:      "2634266614a5d83b296db30a209ed1544985662ffbe116122f513f5bc2741a4c"
    sha256 cellar: :any_skip_relocation, mojave:        "f40a393b0be66d5ce46e3198cc71ed54c82c69e5d5b621f9400040523033781d"
  end

  depends_on "go" => :build

  def install
    system "make", "vela-cli", "VELA_VERSION=#{version}"
    bin.install "bin/vela"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/vela", "completion", "bash")
    (bash_completion/"vela").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/vela", "completion", "zsh")
    (zsh_completion/"_vela").write output
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "Error: invalid configuration: no configuration has been provided", status_output
  end
end
