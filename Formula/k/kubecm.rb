class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "23d347a00285f3a59a3866d02507fe0945c1a46cbef059be249fa436e6cde2c2"
  license "Apache-2.0"
  head "https://github.com/sunny0826/kubecm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13643edd76ccfd2122c2c60fb9fc4aee73a45f7cedfd3ee0b95d4108c3edb848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13643edd76ccfd2122c2c60fb9fc4aee73a45f7cedfd3ee0b95d4108c3edb848"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13643edd76ccfd2122c2c60fb9fc4aee73a45f7cedfd3ee0b95d4108c3edb848"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f453c725f95b8516df976d255b4b7ca052904b53771dae175162c8c84a5bfc6"
    sha256 cellar: :any_skip_relocation, ventura:       "8f453c725f95b8516df976d255b4b7ca052904b53771dae175162c8c84a5bfc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e645b9de456ad66f084ac983eb98fcb2eed017ca6dd20967af5f44b41e112e7"
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
