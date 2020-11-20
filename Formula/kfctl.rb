class Kfctl < Formula
  desc "Kubeflow command-line interface"
  homepage "https://github.com/kubeflow/kfctl"
  url "https://github.com/kubeflow/kfctl.git",
      tag:      "v1.1.0",
      revision: "9a3621e2b2ce6d2baa5c78acccec5028c4e4cbe1"
  license "Apache-2.0"

  depends_on "go@1.13" => :build

  def install
    system "make", "build"
    bin.install "bin/darwin/kfctl"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kfctl", "completion", "bash")
    (bash_completion/"kfctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kfctl", "completion", "zsh")
    (zsh_completion/"kfctl").write output
  end

  test do
    run_output = shell_output("#{bin}/kfctl version 2>&1")
    assert_match "kfctl v1.1.0-0-g9a3621e", run_output
  end
end
