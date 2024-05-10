class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "5e619defed0513721b71d21dc412be01e429167aecdf4297d872ba840863bd72"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a04ad69e70a35f1fc3e4d6925f7e5608826acbc092863e5313b67bd11a9a57a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a04ad69e70a35f1fc3e4d6925f7e5608826acbc092863e5313b67bd11a9a57a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a04ad69e70a35f1fc3e4d6925f7e5608826acbc092863e5313b67bd11a9a57a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8af8efdcb0026c0b97da645aaed67aaef4b4b217b4373a299ca1ff564360f724"
    sha256 cellar: :any_skip_relocation, ventura:        "8af8efdcb0026c0b97da645aaed67aaef4b4b217b4373a299ca1ff564360f724"
    sha256 cellar: :any_skip_relocation, monterey:       "8af8efdcb0026c0b97da645aaed67aaef4b4b217b4373a299ca1ff564360f724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92c236e4236c6667ba68f95e0f77cfbde62497a192ee2951d359e2732679b092"
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
    error = "transport: Error while dialing: dial unix /var/run/nonexistent.sock: connect: no such file or directory"
    assert_match error, crictl_output

    critest_output = shell_output("#{bin}/critest --ginkgo.dryRun 2>&1")
    assert_match "PASS", critest_output
  end
end
