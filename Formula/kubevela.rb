class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v0.3.5",
      revision: "3bc014bc8c8ff915018441e7aa2b6c4ce44c3fb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d677af5b105432ef6a071692c605318e6e06e5f8b91dc8fcc968817b52781ea6"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b033c0b1fd0f94d78bc886037c551bc16a447408428033767605a7eddea78da"
    sha256 cellar: :any_skip_relocation, catalina:      "5cca706366b66834dadfc3feaf1ad3353b594bfc74410cc540bb79fec7ddc30c"
    sha256 cellar: :any_skip_relocation, mojave:        "e338ccdfca542819cddf3fd56668cc34108ce6d87d09fd9c21d6ebaed1332b24"
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
