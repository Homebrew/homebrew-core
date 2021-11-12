class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.16.1.tar.gz"
  sha256 "a9e7876246ff022c3c0d1455693248ebde5729783626727de0f1ce36d4ba8552"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d20d051f8d444671c8d3d30d4e9296758fca132988f81d5e3af7b976b3549a9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c69e10cfd5bb8e6ba6a2c6fecdd96f9e3e3194e9b6d4775556aee21f1a4771e1"
    sha256 cellar: :any_skip_relocation, monterey:       "14f2e9376fcce00f948865c32eba35d2dfea7e4926985a50758a47735d8f4867"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f93737bee8d49b9a2ee1d0babf7d12a83c8163954ed463f1ca838f7ddffe15e"
    sha256 cellar: :any_skip_relocation, catalina:       "275b991475ee798eeec5b88ff36eb7d306f4dd6d3ac6cf5bc78b6066122a25e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "766ebccdc959ddd2e762d2dc17b6e2ff53d647b4848b6043c646c3ae9e00e8ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
           "-ldflags", "-X github.com/sunny0826/kubecm/cmd.kubecmVersion=#{version}",
           *std_go_args

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kubecm", "completion", "bash")
    (bash_completion/"kubecm").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kubecm", "completion", "zsh")
    (zsh_completion/"_kubecm").write output
  end

  test do
    # Should error out as switch context need kubeconfig
    status_output = shell_output("#{bin}/kubecm switch 2>&1", 1)
    assert_match "Error: open", status_output
  end
end
