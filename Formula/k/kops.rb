class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "d4f4a44b721c96aabc6f5039f4ea8ccd4f13ba9c87dc7c4a5d310917121dfb00"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a1f2b6cb8679ecbd6abb6acde45cf923cf5ddfc7760f9eea4865ad3375e9810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12bef62b7c9847213b635519d7343fd6b4da09a4b7a4987ab4bfe387ef1a80f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b8ea6d73739c3cce158c7f72eede6ec51ca75b8691e76404f36a47cbef27b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d457e64a181657c78a56b48e5790b8bf8c9e7272d0453eb7124ab5417a2b019"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6152612b2df1367bcbd4844bbe272f5038718282b071eb6861fe75a18b7b2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "967ada0b6f4bc8a1fabb38d325cfdf1d40e1b036b7951f72681114f9c5813960"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
