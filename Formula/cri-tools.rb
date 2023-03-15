class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/v1.26.1.tar.gz"
  sha256 "3719689d819b497a1579ea2c605df75f771c7428ca710f37e78ee9396c22f773"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dc27aa026bbb1122ec390cefa9d274c13eef9b5e1594fa19b4d4ddc4e8cdf84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dc27aa026bbb1122ec390cefa9d274c13eef9b5e1594fa19b4d4ddc4e8cdf84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dc27aa026bbb1122ec390cefa9d274c13eef9b5e1594fa19b4d4ddc4e8cdf84"
    sha256 cellar: :any_skip_relocation, ventura:        "c4c6e6e5f004bbf524fecc0c7e7f22db95e68c77cea34e9369b9c3971671ec9d"
    sha256 cellar: :any_skip_relocation, monterey:       "c4c6e6e5f004bbf524fecc0c7e7f22db95e68c77cea34e9369b9c3971671ec9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4c6e6e5f004bbf524fecc0c7e7f22db95e68c77cea34e9369b9c3971671ec9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04b584f2a4abcc4d182a9369ccc98b7398c7cc602c11a88ccf958c7da76a7d73"
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
