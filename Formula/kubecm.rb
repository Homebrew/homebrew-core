class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://guoxudong.io/post/kubecm/"
  url "https://github.com/sunny0826/kubecm/archive/v0.10.3.tar.gz"
  sha256 "a17a5ef095014ff3d914156f43b59bd4147145e3e12144fb8084139873772a25"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f359c37e0680f45917d7bcffff2d7cf25ae6c1ea10bc2a988963a6e7417a01d" => :big_sur
    sha256 "aee2facb1875a74299c2ccdea14528f0574ae42197d2499ca79d93bf82a1bead" => :catalina
    sha256 "e617b5a9c595881bf55915fd230ac778c9a9b37abd19bb4731bbad47e5c75451" => :mojave
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
