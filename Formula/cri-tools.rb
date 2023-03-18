class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/v1.26.1.tar.gz"
  sha256 "3719689d819b497a1579ea2c605df75f771c7428ca710f37e78ee9396c22f773"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dbd782b0344cb46ea1b3c0a0b81c2c56e78d79333f0ddf63ab70f2e695f2eed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa260b7cecf38ea6eec580feb8be775429081b1e1878a8dc162a851290b459bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a32bb41079a4388576c93e749cdcd1dab631e8202b124de7c331c0e2acc89a4"
    sha256 cellar: :any_skip_relocation, ventura:        "5da498bf3f7af2041d9e63bf108ab93af80aef35fecf26a8ba468eeed01301e7"
    sha256 cellar: :any_skip_relocation, monterey:       "13759573e0946ef8c0a1ac10048bffec020215820583857a18bfa848dcb455b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a722b438f90415364265ead00ce633392619b80f41190b41e88ae8d66e9c590f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8493b8eb9c123d77f479da21db6d794cd4693b0f345ee43c66a806f160aa85"
  end

  depends_on "go" => :build

  def install
    ENV["BINDIR"] = bin

    if build.head?
      system "make", "install"
    else
      system "make", "install", "VERSION=#{version}"
    end

    generate_completions_from_executable(bin/"crictl", "completion", base_name: "crictl")
  end

  test do
    crictl_output = shell_output(
      "#{bin}/crictl --runtime-endpoint unix:///var/run/nonexistent.sock --timeout 10ms info 2>&1", 1
    )
    assert_match "Status from runtime service failed", crictl_output

    critest_output = shell_output("#{bin}/critest --ginkgo.dryRun 2>&1")
    assert_match "PASS", critest_output
  end
end
