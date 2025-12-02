class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "f6b61d7be1aeafc4f320b289c5d63bd405ef2f8abbc0ced57f7c1c10e42b51ac"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fed8fa5ee46bdfc1774489723d220e2f5befbf711b722a21b6a7dfbc9a7ff7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "759ecd4c274edb762fb44f765babd1a1dde0ff004f34ecc75c4fbc8073409389"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "219fe9ccf8d6ed670dce32c6546ca23c4348b0dc47c6f04c3bc0ea6b6c07cc4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f7b5a35bf3e8f5aeae24476d4fc40c02106318486c7668460a25738a1f67ed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99dcf090cb04e4330ad784128f73777207dfa4c03b4688789d4a0e07d1c1e2e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f2d0034aa2e5ad6b506155cfadad9cad8daa7a35595d2ed66218c7458260041"
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
