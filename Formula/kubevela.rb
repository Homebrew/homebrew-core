class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.0.6",
      revision: "5d9b3fbce6dc2eaee69dfe664930df3e553d1176"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a50f89f958514f89c5a44ef05458d2c2dd2fe9bccd5007d737cd7f777ef1b01"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a31199f9c0fa2ee423a088db44ea9537d55804479f542e449ca5d0d980a8b7d"
    sha256 cellar: :any_skip_relocation, catalina:      "7e7c646c8e7b28aeb2d35e3816d602b0d7036d39967c31873d42788ce3aecf8d"
    sha256 cellar: :any_skip_relocation, mojave:        "273866f46d168f9ec8127f9a971ade54cbf5f0a5c4d320f5e1fed139e0b65b7c"
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
