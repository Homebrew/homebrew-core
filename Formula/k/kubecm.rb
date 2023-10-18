class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.25.0.tar.gz"
  sha256 "d9152b28f9af4c9f27b3a871fb0efba7aed4f6263d34c39310e5c92a2dfc9a19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a234c398875476bbe86c66b2debb4924dd02cfc9ee8723430add0f2e8965a8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71798c2ad67d0df1a42aa7e2653764dab6802309063a42a89ecd733a99d7647e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71798c2ad67d0df1a42aa7e2653764dab6802309063a42a89ecd733a99d7647e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71798c2ad67d0df1a42aa7e2653764dab6802309063a42a89ecd733a99d7647e"
    sha256 cellar: :any_skip_relocation, sonoma:         "18e47881cb65d048adb9e74ae485eee84491924601a2794eb91c7669f9a56b24"
    sha256 cellar: :any_skip_relocation, ventura:        "89013120557c8f236f2bb1478c23ba9e993c9f8647035a3d43babe9980a42cc4"
    sha256 cellar: :any_skip_relocation, monterey:       "89013120557c8f236f2bb1478c23ba9e993c9f8647035a3d43babe9980a42cc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "89013120557c8f236f2bb1478c23ba9e993c9f8647035a3d43babe9980a42cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7401cc02a5c5bbf588a8416da69dcf0281ee119b15436480c184f586e07ede0b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
