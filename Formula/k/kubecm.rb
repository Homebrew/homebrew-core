class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "ae03e76d4401c1d705a4a2684d5ba2eef8e8eb47a30df5bb80abfb65ba19f34a"
  license "Apache-2.0"
  head "https://github.com/sunny0826/kubecm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29c168a553c3504bb4389284cb38536b772eb80ad969d2f584eaf8b821686466"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29c168a553c3504bb4389284cb38536b772eb80ad969d2f584eaf8b821686466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29c168a553c3504bb4389284cb38536b772eb80ad969d2f584eaf8b821686466"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66efde356eb0be1587f763c9646afd315d04721cc9437eb395e4da35edb89910"
    sha256 cellar: :any,                 x86_64_linux:      "d5eb5aa29bd3bbedbdfb9ef0876160a6690ed49ecdcf39e15d8f9e41acd3b4dd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubecm", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
