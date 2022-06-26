class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/v1.24.2.tar.gz"
  sha256 "cd70395a2a856a77785d231d41d3640fb6da4ba7b144f4242a938312b64855a0"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd320fc241012fbe9df7f22c82357a5f9bf70b9613e1e18c6e40e0018fa65c1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd320fc241012fbe9df7f22c82357a5f9bf70b9613e1e18c6e40e0018fa65c1b"
    sha256 cellar: :any_skip_relocation, monterey:       "065c4ea941a93e5cd0daf3f3bae1fa332af41b71b34d3ecb5d0d2c63e537145d"
    sha256 cellar: :any_skip_relocation, big_sur:        "065c4ea941a93e5cd0daf3f3bae1fa332af41b71b34d3ecb5d0d2c63e537145d"
    sha256 cellar: :any_skip_relocation, catalina:       "065c4ea941a93e5cd0daf3f3bae1fa332af41b71b34d3ecb5d0d2c63e537145d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6734a23f6cb20b736d5df7d1dc1b67a1a61ffff99171a92a08507eee77be6bdb"
  end

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
    assert_match "unable to determine runtime API version", crictl_output

    critest_output = shell_output("#{bin}/critest --ginkgo.dryRun 2>&1")
    assert_match "PASS", critest_output
  end
end
