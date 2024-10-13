class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "465bd14768a86a782c6e4b15b3683c4a5efd0363d68b241d5757a7bada9bcd21"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "22360ee3f10a8868ce75f8f79f47a46307cd526a499948cf3a50882a7a3f0097"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fa37dab5b7d97eafcabf743e4b0f10c9e58c0c589f01967c9944e8a3ad3b437"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fa37dab5b7d97eafcabf743e4b0f10c9e58c0c589f01967c9944e8a3ad3b437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fa37dab5b7d97eafcabf743e4b0f10c9e58c0c589f01967c9944e8a3ad3b437"
    sha256 cellar: :any_skip_relocation, sonoma:         "37ab62d27f08b4ee61bfeffbcb2fc24b785d6fc28fdda98d00783ea3dcc8eb97"
    sha256 cellar: :any_skip_relocation, ventura:        "37ab62d27f08b4ee61bfeffbcb2fc24b785d6fc28fdda98d00783ea3dcc8eb97"
    sha256 cellar: :any_skip_relocation, monterey:       "37ab62d27f08b4ee61bfeffbcb2fc24b785d6fc28fdda98d00783ea3dcc8eb97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6ee084f2f349c9081bc67d2244f9478308c5c5d736fd303f5b46a03892cfc63"
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
