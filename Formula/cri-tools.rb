class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/v1.22.0.tar.gz"
  sha256 "76fc230a73dd7e8183f499c88effaf734540808f2f90287031a85d0a4d8512d9"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  depends_on "go" => :build

  def install
    ENV["BINDIR"] = bin

    if build.head?
      system "make", "install"
    else
      system "make", "install", "VERSION=#{version}"
    end

    output = Utils.safe_popen_read("#{bin}/crictl", "completion", "bash")
    (bash_completion/"crictl").write output

    output = Utils.safe_popen_read("#{bin}/crictl", "completion", "zsh")
    (zsh_completion/"_crictl").write output

    output = Utils.safe_popen_read("#{bin}/crictl", "completion", "fish")
    (fish_completion/"crictl.fish").write output
  end

  test do
    crictl_output = shell_output(
      "#{bin}/crictl --runtime-endpoint unix:///var/run/nonexistent.sock --timeout 10ms info 2>&1", 1
    )
    assert_match "context deadline exceeded", crictl_output

    critest_output = shell_output("#{bin}/critest --ginkgo.dryRun 2>&1")
    assert_match "PASS", critest_output
  end
end
