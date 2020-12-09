class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
    tag:      "v0.2.1",
    revision: "bb6b050d158e5226d81caa2749daaa11edae586a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "496c4a442d98b68f7f2d12ca5888a7585d0074ad6a0b794a9db190f96fede506" => :big_sur
    sha256 "e6445adb63a542e5684ec4c7396842a99544d87a507de8cb8762778c87abde3b" => :catalina
    sha256 "6c70afb1e7f05898cfbf721ebd7f6f37239e9d00fc850d2e538a8ee3ddc4a644" => :mojave
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
