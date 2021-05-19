class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.0.5",
      revision: "53b49aca5385c686241165b19ab861c6f54d3e8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35b9b216f9d9d77ac78520f28f8a4fedede97f5565eef08b568f0a631aaacd70"
    sha256 cellar: :any_skip_relocation, big_sur:       "b92debb1ae392b7157a88c39962b67623ebdd991a4b0cf3c69c1cccbdd967f1e"
    sha256 cellar: :any_skip_relocation, catalina:      "443472ffb802464bedd992a12f151bc54d1049ea46f9331557120d3ccbfd3704"
    sha256 cellar: :any_skip_relocation, mojave:        "408bab62c1f536a863bf4496282279e5661e145fd71adee7bac281bb2a75afd5"
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
