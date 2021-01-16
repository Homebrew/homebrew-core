class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v0.3.0",
      revision: "a10dccf5bd194f3d9a20ad8d2c5133e913d5e9b7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fe892630f78f4007270864612b48bea7443453b7544c6125d601c96f32963265" => :big_sur
    sha256 "2194e8592b6a2e8bfffe4ba8277e3f905d3c99453c39ef5a5fb9cbcb493b4c6e" => :arm64_big_sur
    sha256 "a4355a354323936ff5b71f3363ef39bdd35198c9177857918fe3b4d98a5d3ee0" => :catalina
    sha256 "27f3f0fd5ae62a7016af0a82e26b950eba4c94d58d24e2f368dbfbcdc71123aa" => :mojave
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
