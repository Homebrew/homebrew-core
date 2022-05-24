class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/v1.24.1.tar.gz"
  sha256 "aed703b1163c43bdb82b17d86451b520f8c605b2d7a26693eb5936afaf0a3e38"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a07bb8823636c1302757dc9d9a08d723e2fa646994ede8d5a2b000ec7c76adcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a07bb8823636c1302757dc9d9a08d723e2fa646994ede8d5a2b000ec7c76adcf"
    sha256 cellar: :any_skip_relocation, monterey:       "869aa39a5eab3ffdc5788110d4f4c9990fae441d600e2ebc970861ae4f8b300f"
    sha256 cellar: :any_skip_relocation, big_sur:        "869aa39a5eab3ffdc5788110d4f4c9990fae441d600e2ebc970861ae4f8b300f"
    sha256 cellar: :any_skip_relocation, catalina:       "869aa39a5eab3ffdc5788110d4f4c9990fae441d600e2ebc970861ae4f8b300f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b8011cab6cbb45bbbfc35068d36efc4e0d90ed02776d27da187ff2026ea4d0b"
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
