class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/v1.24.1.tar.gz"
  sha256 "aed703b1163c43bdb82b17d86451b520f8c605b2d7a26693eb5936afaf0a3e38"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d962159b8e8280d96805ae736d4bebf816319fb26ed04b2240c2a1e58767be70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d962159b8e8280d96805ae736d4bebf816319fb26ed04b2240c2a1e58767be70"
    sha256 cellar: :any_skip_relocation, monterey:       "9f348ee2e484cd03e8569cfef8be86d783966d443d6910695020b7183f72bc2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f348ee2e484cd03e8569cfef8be86d783966d443d6910695020b7183f72bc2a"
    sha256 cellar: :any_skip_relocation, catalina:       "9f348ee2e484cd03e8569cfef8be86d783966d443d6910695020b7183f72bc2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51b02c8fd89aaf71142ea32f33f93a6335b2784391c7df5999bc17dccb3105db"
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
