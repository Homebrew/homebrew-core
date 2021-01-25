class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.14.0.tar.gz"
  sha256 "05399c517ea632849e2f500ce50f0b95da97fecfacb7e129b2b4d51dbf80f0cd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7757369261a5c7d40cdb04142db6611f0380b98ac2af586f21844dc1732802c3" => :big_sur
    sha256 "5bf8d656174d2639ccd9e34941980a8ff80c7542a911ad2131866a80aa6632b7" => :arm64_big_sur
    sha256 "399db5e8bb27e86ac3a419cf501bdba2375a71f043f329cea4f96d3577fc62df" => :catalina
    sha256 "982f00093846cd65e112049e1c86602da029b6d2b05c56f78a74c705de3039d3" => :mojave
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
