class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "2dec9f042984d5d05e8f2ffa4d2c475ed9339d05ae71c95f9674e9e6aeb9ac1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62464e84fe54de407a31be4c0c855a31a7abca48ea2070666652109771869401"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62464e84fe54de407a31be4c0c855a31a7abca48ea2070666652109771869401"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62464e84fe54de407a31be4c0c855a31a7abca48ea2070666652109771869401"
    sha256 cellar: :any_skip_relocation, sonoma:        "a131cc3291d74e7d2a6170724738e486623677c22ed296cea468d5cd3433dc8f"
    sha256 cellar: :any_skip_relocation, ventura:       "a131cc3291d74e7d2a6170724738e486623677c22ed296cea468d5cd3433dc8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4350844f68c8d20c42c5e2034f134481d25003406fd9fa8ea1a376c562a4a378"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
