class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v0.3.6",
      revision: "df8fb9369ba9ae3923d21ed2090a78a581e48f82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1409808a47e2dac8675a095fa9f827af0bd5997497225681818e5893619fc39a"
    sha256 cellar: :any_skip_relocation, big_sur:       "ddb64bf6a9bbf6f0d7a26cdfff455f42b899b3823c7f3864541c9220bad283f6"
    sha256 cellar: :any_skip_relocation, catalina:      "863d146ee3114f10f98828d3815c2893ad533e559c1e1c64d83bcc3edf33999f"
    sha256 cellar: :any_skip_relocation, mojave:        "b8436e5ad3ea0ff5fa94d3a46bfa7a5c2936fab441585d47d1c1107daa542812"
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
