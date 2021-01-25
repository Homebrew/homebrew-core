class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v0.3.0",
      revision: "a10dccf5bd194f3d9a20ad8d2c5133e913d5e9b7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e7cc0973d4fde6169bf75ac51554b1b42685470143128d3ec7f9a9abae5740f" => :big_sur
    sha256 "a00b75cb7d88016ec27398280273ee53638ffcbbeb1aaad7e59fdad8ae085a17" => :arm64_big_sur
    sha256 "d6d246b5cfb6f9fb882c03bbec2ac1ba939eec581b00998131fcef8a13141d29" => :catalina
    sha256 "e3ef2db6da299de84162fc0358b9afbd5c520b164cb986f9d2a495d054925cec" => :mojave
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
